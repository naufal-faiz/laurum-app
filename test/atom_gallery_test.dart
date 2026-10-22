import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import '../widgetbook/atoms/app_card_use_case.dart';
import '../widgetbook/atoms/app_divider_use_case.dart';
import '../widgetbook/atoms/app_gap_use_case.dart';
import '../widgetbook/atoms/app_icon_use_case.dart';
import '../widgetbook/atoms/app_text_use_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final font in {
      'Plus Jakarta Sans': 'assets/fonts/PlusJakartaSans.ttf',
      'IBM Plex Mono': 'assets/fonts/IBMPlexMono-Regular.ttf',
      'packages/ionicons/Ionicons': 'packages/ionicons/assets/fonts/Ionicons.ttf',
    }.entries) {
      final loader = FontLoader(font.key)..addFont(rootBundle.load(font.value));
      await loader.load();
    }
  });
  for (final entry in {
    'app_text': appTextUseCase,
    'app_icon': appIconUseCase,
    'app_gap': appGapUseCase,
    'app_divider': appDividerUseCase,
    'app_card': appCardUseCase,
  }.entries) {
    testWidgets('${entry.key} gallery renders all variants', (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: RepaintBoundary(
            key: const ValueKey('gallery'),
            child: Scaffold(body: Builder(builder: entry.value.builder)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('gallery')),
        matchesGoldenFile('goldens/${entry.key}.png'),
      );
    });
  }
}
