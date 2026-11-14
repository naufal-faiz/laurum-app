import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

void main() {
  testWidgets('card gradient is opt-in and inverse badge uses existing blue surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Column(
            children: [
              AppCard(child: Text('Default')),
              AppCard(style: AppCardStyle.primary, gradient: true, child: Text('Gradient')),
              AppBadge('Kiloan', variant: AppBadgeVariant.inverse),
            ],
          ),
        ),
      ),
    );
    final backgrounds = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .toList();
    expect(backgrounds.where((style) => style.gradient != null), hasLength(1));
    final gradient =
        backgrounds.singleWhere((style) => style.gradient != null).gradient! as LinearGradient;
    expect(gradient.colors, [AppColors.heroGradientStart, AppColors.heroGradientEnd]);
    expect(gradient.begin, Alignment.topLeft);
    expect(gradient.end, Alignment.bottomRight);
    expect(backgrounds.any((style) => style.color == AppColors.illustration), isTrue);
    expect(tester.widget<Text>(find.text('Kiloan')).style!.color, AppColors.onPrimary);
  });
  for (final dense in [false, true]) {
    testWidgets('currency prefix dense=$dense leaves zero as hint and forwards digits', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppTextField(
              label: 'Harga',
              hint: '0',
              dense: dense,
              prefixText: 'Rp ',
              onChanged: (value) => changed = value,
            ),
          ),
        ),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, isEmpty);
      expect(field.decoration!.hintText, '0');
      expect(find.text('Rp'), findsOneWidget);
      expect(tester.getCenter(find.text('Rp')).dy, closeTo(tester.getCenter(find.text('0')).dy, 2));
      expect(field.decoration!.prefixIcon, isNotNull);
      await tester.enterText(find.byType(TextField), '7500');
      expect(changed, '7500');
      expect(tester.takeException(), isNull);
    });
  }
}
