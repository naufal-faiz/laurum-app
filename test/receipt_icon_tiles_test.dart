import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';

import 'r9_section_host.dart';

void main() {
  for (final (variant, color) in [
    (AppIconButtonVariant.tilePrimary, AppColors.primaryTint),
    (AppIconButtonVariant.tileSuccess, AppColors.successTint),
    (AppIconButtonVariant.tileNeutral, AppColors.surfaceLow),
  ]) {
    testWidgets('$variant has a 48 dp target, tooltip and disabled state', (tester) async {
      var taps = 0;
      await pumpR9Section(
        tester,
        AppIconButton(
          variant: variant,
          icon: AppIcons.download,
          label: 'Unduh',
          onPressed: () => taps++,
        ),
      );
      final button = find.byType(IconButton);
      expect(tester.getSize(button), const Size.square(48));
      expect(tester.widget<IconButton>(button).style!.backgroundColor!.resolve({}), color);
      await tester.tap(find.byTooltip('Unduh'));
      expect(taps, 1);
      await pumpR9Section(
        tester,
        AppIconButton(variant: variant, icon: AppIcons.download, label: 'Unduh'),
      );
      expect(tester.widget<IconButton>(button).onPressed, isNull);
    });
  }
}
