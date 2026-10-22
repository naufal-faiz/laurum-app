import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

void main() {
  testWidgets('AppText renders every typography variant and forwards text options', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            for (final variant in AppTextVariant.values)
              AppText(
                variant.name,
                variant: variant,
                color: AppColors.primary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
    for (final variant in AppTextVariant.values) {
      final text = tester.widget<Text>(find.text(variant.name));
      expect(text.style, variant.style.copyWith(color: AppColors.primary));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.textAlign, TextAlign.center);
    }
    expect(tester.widget<Text>(find.text('body')).style?.fontFamily, AppTextStyles.fontFamily);
    expect(
      tester.widget<Text>(find.text('monoReceipt')).style?.fontFamily,
      AppTextStyles.monoFamily,
    );
  });
}
