import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

const _body = Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  spacing: AppSpacing.cardGap,
  children: [
    AppText('Isi sheet dapat digulir.', variant: AppTextVariant.section),
    AppText('Footer aksi tetap di bawah bila disediakan.'),
  ],
);

final _surface = Material(
  color: AppColors.surface,
  borderRadius: AppRadius.sheet,
  clipBehavior: Clip.antiAlias,
  child: AppBottomSheet(
    title: 'Input berat',
    subtitle: 'Cuci setrika · Rp9.000/kg',
    child: SheetScaffold(
      footer: AppButton('Simpan berat', onPressed: () {}),
      child: _body,
    ),
  ),
);

final sheetScaffoldUseCases = [
  WidgetbookUseCase(
    name: 'Dengan footer',
    builder: (context) => Scaffold(
      body: Align(alignment: Alignment.bottomCenter, child: _surface),
    ),
  ),
  WidgetbookUseCase(
    name: 'Tanpa footer',
    builder: (context) => const Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: AppColors.surface,
          borderRadius: AppRadius.sheet,
          clipBehavior: Clip.antiAlias,
          child: AppBottomSheet(
            title: 'Input berat',
            subtitle: 'Cuci setrika · Rp9.000/kg',
            child: SheetScaffold(child: _body),
          ),
        ),
      ),
    ),
  ),
];
