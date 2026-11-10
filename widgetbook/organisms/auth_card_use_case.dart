import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/organisms/auth_card.dart';
import 'package:widgetbook/widgetbook.dart';

final authCardUseCase = WidgetbookUseCase(
  name: 'Contoh form',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: AuthCard(
      children: [
        const AppTextField(label: 'Email', hint: 'nama@email.com'),
        const AppTextField(label: 'Password', obscureText: true),
        AppButton('Masuk', icon: AppIcons.arrowForward, onPressed: () {}),
      ],
    ),
  ),
);
