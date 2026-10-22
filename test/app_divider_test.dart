import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';

void main() {
  testWidgets('AppDivider fills bounded width or height with the border token', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: Column(
              children: [
                AppDivider(key: ValueKey('horizontal')),
                Expanded(
                  child: AppDivider(key: ValueKey('vertical'), axis: Axis.vertical),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('horizontal'))),
      const Size(200, AppDimensions.line),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('vertical'))),
      const Size(AppDimensions.line, 100 - AppDimensions.line),
    );
    for (final box in tester.widgetList<ColoredBox>(
      find.descendant(of: find.byType(AppDivider), matching: find.byType(ColoredBox)),
    )) {
      expect(box.color, AppColors.border);
    }
  });
}
