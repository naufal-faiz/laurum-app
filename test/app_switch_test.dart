import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

void main() {
  testWidgets('switch renders variants and respects its public contract', (tester) async {
    bool? changed;
    final semantics = tester.ensureSemantics();
    try {
      for (final value in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: AppSwitch(value: value, label: 'Setting', onChanged: (next) => changed = next),
            ),
          ),
        );
        expect(tester.getSize(find.byType(AppSwitch)), const Size(48, 48));
        expect(
          tester.getSemantics(find.byType(AppSwitch)).flagsCollection.isToggled == Tristate.isTrue,
          value,
        );
        await tester.tap(find.byType(TextButton));
        expect(changed, !value);
        expect(tester.widget<AppSwitch>(find.byType(AppSwitch)).value, value);
      }
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: AppSwitch(value: false, label: 'Disabled')),
        ),
      );
      expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
    } finally {
      semantics.dispose();
    }
  });
}
