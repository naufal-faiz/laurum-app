import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

void main() {
  testWidgets('badge renders variants and respects its public contract', (tester) async {
    for (final variant in AppBadgeVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: AppBadge(variant.name, variant: variant)),
        ),
      );
      expect(find.text(variant.name), findsOneWidget);
      expect(tester.getSize(find.byType(AppBadge)).height, 20);
      final text = tester.widget<AppText>(find.byType(AppText));
      expect(text.variant, AppTextVariant.label);
      expect(text.color, switch (variant) {
        AppBadgeVariant.diproses => AppColors.blueInk,
        AppBadgeVariant.siap => AppColors.primary,
        AppBadgeVariant.menungguJemput || AppBadgeVariant.selesai => AppColors.slateInk,
        AppBadgeVariant.dibatalkan => AppColors.errorInk,
      });
    }
  });
}
