import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_gap.dart';

void main() {
  testWidgets('AppGap reserves space only on its selected axis', (tester) async {
    await tester.pumpWidget(
      const Center(
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppGap(key: ValueKey('vertical')),
            AppGap(
              key: ValueKey('horizontal'),
              axis: Axis.horizontal,
              size: AppSpacing.screenPadding,
            ),
          ],
        ),
      ),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('vertical'))),
      const Size(0, AppSpacing.cardGap),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('horizontal'))),
      const Size(AppSpacing.screenPadding, 0),
    );
  });
}
