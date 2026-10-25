import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:widgetbook/widgetbook.dart';

final bottomNavBarUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (var i = 0; i < 4; i++)
          BottomNavBar(activeIndex: i, onSelected: (_) {}, onCreate: () {}),
        const BottomNavBar(activeIndex: 0),
      ],
    ),
  ),
);
