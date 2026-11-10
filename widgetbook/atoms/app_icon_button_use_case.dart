import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:widgetbook/widgetbook.dart';

final appIconButtonUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.cardGap,
      children: [
        AppIconButton(icon: AppIcons.person, label: 'Enabled', onPressed: () {}),
        const AppIconButton(icon: AppIcons.person, label: 'Disabled'),
        AppIconButton(
          variant: AppIconButtonVariant.hero,
          iconAsset: AppSvgs.cursorBack,
          label: 'Kembali',
          onPressed: () {},
        ),
      ],
    ),
  ),
);
