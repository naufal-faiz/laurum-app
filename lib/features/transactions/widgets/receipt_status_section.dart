import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/receipt_print_controller.dart';
import 'package:laurum/features/transactions/pages/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class ReceiptStatusPage extends ConsumerWidget {
  const ReceiptStatusPage({required this.view, super.key});
  final ReceiptView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printState = ref.watch(receiptPrintProvider);
    final service = ref.watch(printServiceProvider);
    final paid = paidAmount(view.payments, orderId: view.order.id);
    final status = payStatus(total: view.order.total, paid: paid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText('Nomor nota', variant: AppTextVariant.caption),
                        AppText(view.order.orderNo, variant: AppTextVariant.titleSub),
                      ],
                    ),
                  ),
                  AppStatusText(
                    switch (status) {
                      PayStatus.lunas => 'Lunas',
                      PayStatus.dp => 'DP',
                      PayStatus.belumBayar => 'Belum bayar',
                    },
                    variant: AppStatusTextVariant.values.byName(status.name),
                  ),
                ],
              ),
              const AppText('Pembayaran tersimpan.'),
              AppText(
                service.connectedPrinter == null
                    ? 'Printer belum terhubung'
                    : 'Printer Bluetooth: ${service.connectedPrinter!.name} (Terhubung)',
                color: service.status == PrintStatus.connected ? AppColors.primary : AppColors.ink3,
              ),
            ],
          ),
        ),
        if (printState.error != null) ...[
          BannerMessage(message: printState.error!, variant: BannerMessageVariant.error),
          Row(
            spacing: AppSpacing.cardGap,
            children: [
              Expanded(
                child: AppButton(
                  'Coba lagi',
                  onPressed: printState.printing
                      ? null
                      : () => ref.read(receiptPrintProvider.notifier).printReceipt(view),
                ),
              ),
              Expanded(
                child: AppButton(
                  'Pengaturan printer',
                  variant: AppButtonVariant.actionOutline,
                  onPressed: () => context.push('/lainnya/printer'),
                ),
              ),
            ],
          ),
        ],
        if (printState.notice != null) BannerMessage(message: printState.notice!),
      ],
    );
  }
}
