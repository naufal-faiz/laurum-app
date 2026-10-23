import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';
import 'package:widgetbook/widgetbook.dart';

final footerBarUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        FooterBar(child: AppButton('Continue', onPressed: () {})),
        FooterBar(
          summary: const AppText('Summary'),
          child: AppButton('Submit', onPressed: () {}),
        ),
        FooterBar(
          child: Row(
            spacing: AppSpacing.cardGap,
            children: [
              Expanded(
                child: AppButton('Cancel', variant: AppButtonVariant.secondary, onPressed: () {}),
              ),
              Expanded(child: AppButton('Confirm', onPressed: () {})),
            ],
          ),
        ),
      ],
    ),
  ),
);
