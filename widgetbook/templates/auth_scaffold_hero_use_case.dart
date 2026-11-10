import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/organisms/auth_card.dart';
import 'package:laurum/shared/widgets/organisms/auth_hero.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

final authScaffoldHeroUseCase = WidgetbookUseCase(
  name: 'Dengan hero',
  builder: (context) => AuthScaffold(
    hero: const AuthHero(
      height: 230,
      title: 'Daftar',
      subtitle: 'Buat akun untuk mulai mengelola usaha',
    ),
    contentTop: 200,
    background: AppColors.surface,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
      child: AuthCard(
        children: [
          const AppText('Laurum', variant: AppTextVariant.titleRoot),
          const LabeledField(
            label: 'Email',
            child: AppTextField(label: 'Email', hint: 'nama@email.com'),
          ),
          AppButton('Daftar', onPressed: () {}),
        ],
      ),
    ),
  ),
);
