import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:lottie/lottie.dart';

void main() {
  setUpAll(() async {
    final composition = await AssetLottie('assets/animations/laurum-loader.json').load();
    expect([composition.bounds.width, composition.bounds.height], [400, 400]);
    expect(composition.duration, const Duration(seconds: 6));
  });
  for (final reducedMotion in [false, true]) {
    testWidgets('loader semantics and motion, reduced=$reducedMotion', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: const Center(child: AppLoader()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.bySemanticsLabel('Sedang memuat'), findsOneWidget);
      final player = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
      expect(player.animate, !reducedMotion);
      expect(player.controller?.value, reducedMotion ? 0.5 : null);
      expect(player.width, 96);
      expect(player.height, 96);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.binding.transientCallbackCount, 0);
      semantics.dispose();
    });
  }
}
