import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:widgetbook/widgetbook.dart';

import 'atoms/app_card_use_case.dart';
import 'atoms/app_divider_use_case.dart';
import 'atoms/app_gap_use_case.dart';
import 'atoms/app_icon_use_case.dart';
import 'atoms/app_text_use_case.dart';

void main() {
  runApp(
    ProviderScope(
      child: Widgetbook.material(
        directories: [
          WidgetbookFolder(
            name: 'Atoms',
            children: [
              WidgetbookComponent(name: 'AppText', useCases: [appTextUseCase]),
              WidgetbookComponent(name: 'AppIcon', useCases: [appIconUseCase]),
              WidgetbookComponent(name: 'AppGap', useCases: [appGapUseCase]),
              WidgetbookComponent(name: 'AppDivider', useCases: [appDividerUseCase]),
              WidgetbookComponent(name: 'AppCard', useCases: [appCardUseCase]),
            ],
          ),
        ],
        lightTheme: AppTheme.light,
        themeMode: ThemeMode.light,
        appBuilder: (context, child) => MaterialApp(
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: child),
        ),
        home: const Scaffold(),
      ),
    ),
  );
}
