import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

void main() {
  testWidgets('status_text renders variants and respects its public contract', (tester) async {
    for (final variant in AppStatusTextVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: AppStatusText(variant.name, variant: variant)),
        ),
      );
      expect(find.text(variant.name), findsOneWidget);
      expect(find.byType(DecoratedBox), findsNothing);
      expect(tester.widget<AppText>(find.byType(AppText)).color, switch (variant) {
        AppStatusTextVariant.lunas => AppColors.primary,
        AppStatusTextVariant.belumBayar => AppColors.error,
        AppStatusTextVariant.dp => AppColors.warningInk,
      });
    }
  });
}
