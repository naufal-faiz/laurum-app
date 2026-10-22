import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';

void main() {
  testWidgets('skeleton preserves requested dimensions and has no animation', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [AppSkeleton(width: 96, height: 16), AppSkeleton(height: 48)],
            ),
          ),
        ),
      ),
    );
    final blocks = find.byType(AppSkeleton);
    expect(tester.getSize(blocks.at(0)), const Size(96, 16));
    expect(tester.getSize(blocks.at(1)), const Size(300, 48));
    final decoration =
        tester.widget<DecoratedBox>(find.byType(DecoratedBox).first).decoration as BoxDecoration;
    expect(decoration.color, AppColors.chipIdle);
    expect(find.byType(ExcludeSemantics), findsNWidgets(2));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
