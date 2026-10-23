import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:widgetbook/widgetbook.dart';

final appBarSubUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppBarSub(title: 'Subpage', backLabel: 'Back', onBack: () {}),
        AppBarSub(
          title: 'Subpage with action',
          backLabel: 'Back',
          onBack: () {},
          trailing: AppIconButton(AppIcons.more, label: 'More', onPressed: () {}),
        ),
      ],
    ),
  ),
);
