import 'package:flutter/material.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/payment_label.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class ReceiptStatusSection extends StatelessWidget {
  const ReceiptStatusSection({
    required this.view,
    required this.printState,
    required this.printerStatus,
    required this.printerName,
    required this.onRetry,
    required this.onSettings,
    super.key,
  });
  final ReceiptView view;
  final ReceiptPrintState printState;
  final PrintStatus printerStatus;
  final String? printerName;
  final VoidCallback onRetry, onSettings;

  @override
  Widget build(BuildContext context) {
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
              Wrap(
                spacing: AppSpacing.cardGap,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  AppStatusText(
                    paymentLabel(view.order, paid),
                    variant: AppStatusTextVariant.values.byName(status.name),
                  ),
                ],
              ),
              AppText(paid > 0 ? 'Pembayaran tersimpan.' : 'Pembayaran dicatat saat diterima.'),
              AppText(
                printerName == null
                    ? 'Printer belum terhubung'
                    : 'Printer Bluetooth: $printerName (Terhubung)',
                color: printerStatus == PrintStatus.connected ? AppColors.primary : AppColors.ink3,
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
                  onPressed: printState.printing ? null : onRetry,
                ),
              ),
              Expanded(
                child: AppButton(
                  'Pengaturan printer',
                  variant: AppButtonVariant.actionOutline,
                  onPressed: onSettings,
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
