import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';

void main() {
  testWidgets('chip renders variants and respects its public contract', (tester) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    try {
      for (final selected in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: AppChip('Filter', selected: selected, onPressed: () => taps++),
            ),
          ),
        );
        expect(tester.getSize(find.byType(TextButton)).height, 48);
        expect(
          tester.getSemantics(find.byType(AppChip)).flagsCollection.isSelected == Tristate.isTrue,
          selected,
        );
        await tester.tap(find.text('Filter'));
      }
      expect(taps, 2);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: AppChip('Disabled')),
        ),
      );
      expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
    } finally {
      semantics.dispose();
    }
  });
}
