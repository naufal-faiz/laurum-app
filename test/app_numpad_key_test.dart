import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

void main() {
  testWidgets('all keys render correct symbols, invoke callback and honor disabled', (
    tester,
  ) async {
    var taps = 0;
    for (final value in AppNumpadKeyValue.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppNumpadKey(
              value,
              semanticLabel: value == AppNumpadKeyValue.backspace ? 'Delete' : null,
              onPressed: () => taps++,
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(TextButton)).height, 56);
      if (value == AppNumpadKeyValue.backspace) {
        expect(tester.widget<AppIcon>(find.byType(AppIcon)).icon, AppIcons.backspace);
      } else {
        expect(find.text(value.label), findsOneWidget);
      }
      await tester.tap(find.byType(TextButton));
    }
    expect(taps, AppNumpadKeyValue.values.length);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: AppNumpadKey(AppNumpadKeyValue.decimal)),
      ),
    );
    expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
  });
}
