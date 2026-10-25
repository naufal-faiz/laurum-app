import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/features/transactions/widgets/receipt_status_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
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
    return SubScaffold(
      title: 'Nota tersimpan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/antrean'),
      body: view.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 6; i++) const AppSkeleton()],
        ),
        error: (_, _) => const Center(
          child: EmptyState(title: 'Gagal memuat nota', icon: AppIcons.alert),
        ),
        data: (receipt) => receipt == null
            ? const Center(
                child: EmptyState(title: 'Nota tidak ditemukan', icon: AppIcons.receipt),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReceiptStatusSection(view: receipt),
                    const SizedBox(height: AppSpacing.screenPadding),
                    ReceiptPreview(
                      lines: receipt.lines,
                      width: receipt.settings.paperMm == 80 ? 384 : 320,
                    ),
                    const SizedBox(height: AppSpacing.screenPadding),
                    AppButton(
                      'Cetak struk',
                      icon: AppIcons.printer,
                      onPressed: () =>
                          ref.read(receiptPrintProvider.notifier).printReceipt(receipt),
                    ),
                    const SizedBox(height: AppSpacing.cardGap),
                    AppButton(
                      'Kirim lewat WhatsApp',
                      variant: AppButtonVariant.secondary,
                      icon: AppIcons.chat,
                      onPressed: () =>
                          ref.read(receiptPrintProvider.notifier).sendWhatsApp(receipt),
                    ),
                    const SizedBox(height: AppSpacing.cardGap),
                    Row(
                      spacing: AppSpacing.cardGap,
                      children: [
                        Expanded(
                          child: AppButton(
                            'Transaksi baru',
                            variant: AppButtonVariant.actionOutline,
                            onPressed: () => context.go('/transaksi/baru'),
                          ),
                        ),
                        Expanded(
                          child: AppButton(
                            'Lihat order',
                            variant: AppButtonVariant.actionOutline,
                            onPressed: () => context.push('/order/${receipt.order.id}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
