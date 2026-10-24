import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

final authScaffoldUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => AuthScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const AppText('Laurum', variant: AppTextVariant.titleRoot),
        const AppText(
          'Kasir laundry untuk usaha rumahan',
          color: AppColors.ink2,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        const LabeledField(
          label: 'Email',
          child: AppTextField(label: 'Email', hint: 'Masukkan email'),
        ),
        const LabeledField(
          label: 'Kata sandi',
          child: AppTextField(
            label: 'Kata sandi',
            hint: 'Masukkan kata sandi',
            obscureText: true,
          ),
        ),
        AppButton('Masuk', onPressed: () {}),
        AppButton(
          'Lupa kata sandi?',
          variant: AppButtonVariant.actionOutline,
          onPressed: () {},
        ),
      ],
    ),
  ),
);
