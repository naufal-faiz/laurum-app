import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

void main() {
  testWidgets('compact type tile keeps tap and selection semantics without extra radio', (
    tester,
  ) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SizedBox(
              width: 150,
              child: SelectionTile(
                label: 'Kiloan',
                subtitle: 'per kg',
                icon: AppIcons.service,
                compact: true,
                selected: true,
                onPressed: () => taps++,
              ),
            ),
          ),
        ),
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.style!.backgroundColor!.resolve({}), AppColors.primaryTint);
      expect(find.byType(AppIcon), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(TextButton)),
        matchesSemantics(
          label: 'Kiloan\nper kg',
          isButton: true,
          isSelected: true,
          isEnabled: true,
          hasEnabledState: true,
          hasSelectedState: true,
          isFocusable: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      await tester.tap(find.text('Kiloan'));
      expect(taps, 1);
    } finally {
      semantics.dispose();
    }
  });
}
