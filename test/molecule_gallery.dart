import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

void registerMoleculeGolden(String name, WidgetBuilder builder) {
  testWidgets('$name gallery', (tester) async {
    for (final entry in {
      'Plus Jakarta Sans': 'assets/fonts/PlusJakartaSans.ttf',
      'IBM Plex Mono': 'assets/fonts/IBMPlexMono-Regular.ttf',
      'packages/ionicons/Ionicons': 'packages/ionicons/assets/fonts/Ionicons.ttf',
    }.entries) {
      await (FontLoader(entry.key)..addFont(rootBundle.load(entry.value))).load();
    }
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const ValueKey('gallery'),
          child: Scaffold(body: Builder(builder: builder)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('gallery')),
      matchesGoldenFile('goldens/$name.png'),
    );
  });
}
