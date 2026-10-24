import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderPaymentPage extends StatelessWidget {
  const OrderPaymentPage({required this.data, required this.onRecord, super.key});
  final OrderDetailData data;
  final VoidCallback? onRecord;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Riwayat pembayaran'),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            AppStatusText(
              data.paymentLabel,
              variant: AppStatusTextVariant.values.byName(data.paymentStatus.name),
            ),
            InfoRow(label: 'Terbayar', value: Formatters.rupiah(data.paid)),
            InfoRow(label: 'Sisa piutang', value: Formatters.rupiah(data.outstanding)),
            if (!data.isFinal)
              AppButton(
                'Catat pembayaran',
                variant: AppButtonVariant.actionOutline,
                onPressed: data.outstanding <= 0 ? null : onRecord,
              ),
          ],
        ),
      ),
    ],
  );
}
