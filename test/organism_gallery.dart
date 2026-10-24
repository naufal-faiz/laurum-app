import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';

void registerOrganismGallery(String name, WidgetBuilder builder, {double height = 900}) {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('$name gallery', (tester) async {
    for (final entry in {
      'Plus Jakarta Sans': 'assets/fonts/PlusJakartaSans.ttf',
      'IBM Plex Mono': 'assets/fonts/IBMPlexMono-Regular.ttf',
      'packages/ionicons/Ionicons': 'packages/ionicons/assets/fonts/Ionicons.ttf',
    }.entries) {
      await (FontLoader(entry.key)..addFont(rootBundle.load(entry.value))).load();
    }
    tester.view.physicalSize = Size(390, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const ValueKey('organism'),
          child: Scaffold(body: Builder(builder: builder)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('organism')),
      matchesGoldenFile('goldens/$name.png'),
    );
  });
  testWidgets('$name narrow width and enlarged text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(body: Builder(builder: builder)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
