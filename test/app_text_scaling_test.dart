import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/app.dart';

void main() {
  testWidgets('app caps system text at the reference device scale and preserves smaller text', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Ukuran font')),
        ),
      ],
    );
    addTearDown(router.dispose);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    for (final (systemScale, expectedSize) in [
      (0.85, 13.6),
      (1.0, 16.0),
      (1.3, 16.0),
      (2.0, 16.0),
    ]) {
      tester.platformDispatcher.textScaleFactorTestValue = systemScale;
      await tester.pumpWidget(ProviderScope(child: LaurumApp(router: router)));
      await tester.pumpAndSettle();
      final scaler = MediaQuery.textScalerOf(tester.element(find.text('Ukuran font')));
      expect(scaler.scale(16), closeTo(expectedSize, 0.001));
      expect(tester.takeException(), isNull);
    }
  });
}
