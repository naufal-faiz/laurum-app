import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:widgetbook/widgetbook.dart';

import 'atoms/app_avatar_use_case.dart';
import 'atoms/app_badge_use_case.dart';
import 'atoms/app_button_use_case.dart';
import 'atoms/app_card_use_case.dart';
import 'atoms/app_chip_use_case.dart';
import 'atoms/app_divider_use_case.dart';
import 'atoms/app_gap_use_case.dart';
import 'atoms/app_icon_button_use_case.dart';
import 'atoms/app_icon_use_case.dart';
import 'atoms/app_numpad_key_use_case.dart';
import 'atoms/app_search_field_use_case.dart';
import 'atoms/app_skeleton_use_case.dart';
import 'atoms/app_status_text_use_case.dart';
import 'atoms/app_switch_use_case.dart';
import 'atoms/app_text_field_use_case.dart';
import 'atoms/app_text_use_case.dart';
import 'molecules/m1.dart';
import 'molecules/m2.dart';
import 'molecules/m3.dart';
import 'organisms/o1.dart';

void main() {
  runApp(
    ProviderScope(
      child: Widgetbook.material(
        directories: [
          WidgetbookFolder(name: 'Organisms', children: o1Components),
          WidgetbookFolder(
            name: 'Molecules',
            children: [...m1Components, ...m2Components, ...m3Components],
          ),
          WidgetbookFolder(
            name: 'Atoms',
            children: [
              WidgetbookComponent(name: 'AppText', useCases: [appTextUseCase]),
              WidgetbookComponent(name: 'AppIcon', useCases: [appIconUseCase]),
              WidgetbookComponent(name: 'AppGap', useCases: [appGapUseCase]),
              WidgetbookComponent(name: 'AppDivider', useCases: [appDividerUseCase]),
              WidgetbookComponent(name: 'AppAvatar', useCases: [appAvatarUseCase]),
              WidgetbookComponent(name: 'AppBadge', useCases: [appBadgeUseCase]),
              WidgetbookComponent(name: 'AppButton', useCases: [appButtonUseCase]),
              WidgetbookComponent(name: 'AppChip', useCases: [appChipUseCase]),
              WidgetbookComponent(name: 'AppIconButton', useCases: [appIconButtonUseCase]),
              WidgetbookComponent(name: 'AppStatusText', useCases: [appStatusTextUseCase]),
              WidgetbookComponent(name: 'AppSwitch', useCases: [appSwitchUseCase]),
              WidgetbookComponent(name: 'AppNumpadKey', useCases: [appNumpadKeyUseCase]),
              WidgetbookComponent(name: 'AppSearchField', useCases: [appSearchFieldUseCase]),
              WidgetbookComponent(name: 'AppSkeleton', useCases: [appSkeletonUseCase]),
              WidgetbookComponent(name: 'AppTextField', useCases: [appTextFieldUseCase]),
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
