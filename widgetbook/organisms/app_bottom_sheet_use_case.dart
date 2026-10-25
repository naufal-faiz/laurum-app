import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:widgetbook/widgetbook.dart';

final appBottomSheetUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => Align(
    alignment: Alignment.bottomCenter,
    child: AppBottomSheet(
      title: 'Pembayaran',
      subtitle: 'Nota A-0143 · Pak Dedi',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            const AppText('Total tagihan'),
            const AppText('Rp56.500', variant: AppTextVariant.figure),
            AppButton(
              'Simpan dan cetak',
              icon: AppIcons.printer,
              onPressed: () {},
            ),
            AppButton('Simpan saja', variant: AppButtonVariant.secondary, onPressed: () {}),
          ],
        ),
      ),
    ),
  ),
);
