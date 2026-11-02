import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/payment_record_flow.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/widgets/receipt_actions_section.dart';
import 'package:laurum/features/transactions/widgets/receipt_status_section.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/receipt_preview.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ReceiptPage extends ConsumerWidget {
  const ReceiptPage({required this.orderId, super.key});
  final String orderId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(receiptViewProvider(orderId));
    final printing = ref.watch(receiptPrintProvider);
    final printer = ref.watch(printServiceProvider);
    final controller = ref.read(receiptPrintProvider.notifier);
    return SubScaffold(
      title: 'Nota tersimpan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
      body: view.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 6; i++) const AppSkeleton()],
        ),
        error: (_, _) => const EmptyState(title: 'Gagal memuat nota', icon: AppIcons.alert),
        data: (receipt) => receipt == null
            ? const EmptyState(title: 'Nota tidak ditemukan', icon: AppIcons.receipt)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.screenPadding,
                  children: [
                    ReceiptStatusSection(
                      view: receipt,
                      printState: printing,
                      printerStatus: printer.status,
                      printerName: printer.connectedPrinter?.name,
                      onRetry: () => controller.printReceipt(receipt),
                      onSettings: () => context.push('/lainnya/printer'),
                    ),
                    ReceiptPreview(
                      lines: receipt.lines,
                      width: receipt.settings.paperMm == 80 ? 384 : 320,
                    ),
                    ReceiptActionsSection(
                      busy: printing.printing,
                      onPrint: () => controller.printReceipt(receipt),
                      onWhatsApp: () => controller.sendWhatsApp(receipt),
                      onNew: () => context.go('/transaksi/baru'),
                      onOrder: () => context.push('/order/$orderId'),
                      onRecord:
                          receipt.order.status != OrderStatus.dibatalkan &&
                              paidAmount(receipt.payments, orderId: orderId) < receipt.order.total
                          ? () => openOrderPayment(context, ref, orderId)
                          : null,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
