import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';

import 'test_fonts.dart';

void registerMoleculeGolden(String name, WidgetBuilder builder) {
  testWidgets('$name gallery', (tester) async {
    await loadTestFonts();
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
