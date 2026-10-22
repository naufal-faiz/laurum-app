import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

void main() {
  testWidgets('AppCard renders all rails with token padding, clipping and no shadow', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            for (final rail in AppCardRail.values) AppCard(rail: rail, child: AppText(rail.name)),
          ],
        ),
      ),
    );
    for (final rail in AppCardRail.values) {
      final card = find.widgetWithText(AppCard, rail.name);
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: card, matching: find.byType(DecoratedBox)),
      );
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, AppColors.surface);
      expect(decoration.borderRadius, AppRadius.card);
      expect(decoration.boxShadow, isNull);
      expect((decoration.border! as Border).top.color, AppColors.border);
      final padding = tester.widget<Padding>(
        find.descendant(of: card, matching: find.byType(Padding)),
      );
      expect(padding.padding, const EdgeInsets.all(AppSpacing.cardPadding));
      final rails = find.descendant(of: card, matching: find.byType(Positioned));
      if (rail == AppCardRail.none) {
        expect(rails, findsNothing);
      } else {
        expect(tester.widget<Positioned>(rails).width, AppSpacing.railWidth);
        expect(
          tester
              .widget<ColoredBox>(find.descendant(of: rails, matching: find.byType(ColoredBox)))
              .color,
          rail == AppCardRail.warning ? AppColors.warningBorder : AppColors.error,
        );
      }
    }
    expect(tester.takeException(), isNull);
  });
}
