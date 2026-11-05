import 'package:flutter_test/flutter_test.dart';

// Native I/O runs outside FakeAsync. Pump frames between actions so Riverpod's
// widget scheduler can rebuild invalidated futures before the next await.
Future<T?> driftWidgetStep<T>(WidgetTester tester, Future<T> Function() action) async {
  await tester.pumpAndSettle();
  final result = await tester.runAsync(action);
  await tester.pumpAndSettle();
  return result;
}
