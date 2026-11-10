import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

void main() {
  testWidgets('icon-only button centers icon and responds across its full width', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SizedBox(
            width: 160,
            height: 48,
            child: Tooltip(
              message: 'Cetak struk',
              child: AppButton(
                '',
                variant: AppButtonVariant.actionOutline,
                icon: AppIcons.printer,
                onPressed: () => taps++,
              ),
            ),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(TextButton));
    expect(tester.getCenter(find.byType(AppIcon)), rect.center);
    await tester.tapAt(rect.topLeft + const Offset(8, 24));
    expect(taps, 1);
  });
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
        variant == AppButtonVariant.cta ? 50 : 44,
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
  testWidgets('button sizes, trailing icon and busy state', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              for (final size in AppButtonSize.values)
                AppButton(
                  size.name,
                  size: size,
                  icon: AppIcons.arrowForward,
                  iconPlacement: AppButtonIconPlacement.trailing,
                  onPressed: () => taps++,
                ),
              AppButton('Sibuk', busy: true, onPressed: () => taps++),
            ],
          ),
        ),
      ),
    );
    for (final size in AppButtonSize.values) {
      final button = find.widgetWithText(TextButton, size.name);
      expect(tester.getSize(button).height, switch (size) {
        AppButtonSize.large => 50,
        AppButtonSize.medium => 44,
        AppButtonSize.small => 48,
      });
      if (size == AppButtonSize.small) {
        final material = find.descendant(of: button, matching: find.byType(Material)).first;
        expect(tester.getSize(material).height, 40); // Visual 40, hit target 48.
      }
      final iconCenter = tester.getCenter(
        find.descendant(of: button, matching: find.byType(AppIcon)),
      );
      final labelCenter = tester.getCenter(
        find.descendant(of: button, matching: find.text(size.name)),
      );
      expect(iconCenter.dx, greaterThan(labelCenter.dx));
    }
    await tester.tap(find.widgetWithText(TextButton, AppButtonSize.small.name));
    expect(taps, 1);
    final busy = find.widgetWithText(TextButton, 'Sibuk');
    await tester.tap(busy);
    expect(taps, 1);
    expect(tester.widget<TextButton>(busy).onPressed, isNull);
  });
}
