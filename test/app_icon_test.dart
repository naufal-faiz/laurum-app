import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

void main() {
  testWidgets('AppIcon renders all mapped glyphs and exposes semantic labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Wrap(
          children: [
            for (final icon in AppIcons.values) AppIcon(icon, semanticLabel: icon.name),
          ],
        ),
      ),
    );
    final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
    expect(icons.length, AppIcons.values.length);
    for (var i = 0; i < icons.length; i++) {
      expect(icons[i].icon, AppIcons.values[i].data);
      expect(icons[i].size, AppDimensions.icon);
      expect(icons[i].color, AppColors.ink2);
      expect(icons[i].semanticLabel, AppIcons.values[i].name);
    }
    expect(AppIcons.receipt.data, isNot(AppIcons.receiptActive.data));
  });
}
