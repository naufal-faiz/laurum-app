import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class PrinterElementsSection extends StatelessWidget {
  const PrinterElementsSection({
    required this.showAddress,
    required this.showCustomer,
    required this.showSavings,
    required this.showNote,
    required this.onAddressChanged,
    required this.onCustomerChanged,
    required this.onSavingsChanged,
    required this.onNoteChanged,
    super.key,
  });
  final bool showAddress, showCustomer, showSavings, showNote;
  final ValueChanged<bool> onAddressChanged, onCustomerChanged, onSavingsChanged, onNoteChanged;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xsmall,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxsmall,
          children: [
            AppText(
              'Elemen tampilan nota',
              variant: AppTextVariant.bodyStrong,
            ),
            AppText(
              'Nomor nota & rincian item selalu tampil',
              variant: AppTextVariant.caption,
              color: AppColors.ink3,
            ),
          ],
        ),
        ToggleRow(
          label: 'Alamat & nomor telepon',
          value: showAddress,
          onChanged: onAddressChanged,
        ),
        const AppDivider(),
        ToggleRow(
          label: 'Nama pelanggan',
          value: showCustomer,
          onChanged: onCustomerChanged,
        ),
        const AppDivider(),
        ToggleRow(
          label: 'Tabungan & sisa saldo',
          value: showSavings,
          onChanged: onSavingsChanged,
        ),
        const AppDivider(),
        ToggleRow(
          label: 'Catatan khusus nota',
          value: showNote,
          onChanged: onNoteChanged,
        ),
      ],
    ),
  );
}
