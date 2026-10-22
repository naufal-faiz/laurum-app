import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

void main() {
  testWidgets('button renders variants and respects its public contract', (tester) async {
    var taps = 0;
    for (final variant in AppButtonVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppButton(
              'Action',
              variant: variant,
              icon: AppIcons.check,
              onPressed: () => taps++,
            ),
          ),
        ),
      );
      expect(find.text('Action'), findsOneWidget);
      expect(find.byType(AppIcon), findsOneWidget);
      expect(
        tester.getSize(find.byType(TextButton)).height,
        variant == AppButtonVariant.cta ? 56 : 48,
      );
      await tester.tap(find.byType(TextButton));
    }
    expect(taps, AppButtonVariant.values.length);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: AppButton('Disabled')),
      ),
    );
    await tester.tap(find.byType(TextButton));
    expect(taps, AppButtonVariant.values.length);
    expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);
  });
}
