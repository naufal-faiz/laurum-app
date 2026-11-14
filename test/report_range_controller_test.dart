import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/reports/state/report_range_controller.dart';

void main() {
  test('range draft bounds, restart, same day, month navigation and reset', () {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    final controller = scope.read(reportRangeDraftProvider.notifier);
    controller.begin(
      firstDate: DateTime(2026),
      lastDate: DateTime(2026, 11, 14),
      start: DateTime(2026, 11),
      end: DateTime(2026, 11, 14),
    );
    controller.selectDay(DateTime(2026, 11, 9));
    expect(scope.read(reportRangeDraftProvider)!.canApply, isFalse);
    controller.selectDay(DateTime(2026, 11, 9));
    expect(scope.read(reportRangeDraftProvider)!.canApply, isTrue);
    controller.selectDay(DateTime(2026, 11, 10));
    controller.selectDay(DateTime(2026, 11, 8));
    expect(scope.read(reportRangeDraftProvider)!.start, DateTime(2026, 11, 8));
    expect(scope.read(reportRangeDraftProvider)!.end, isNull);
    controller.selectDay(DateTime(2026, 11, 14));
    controller.selectDay(DateTime(2026, 11, 15));
    expect(scope.read(reportRangeDraftProvider)!.end, DateTime(2026, 11, 14));
    controller.moveMonth(DateTime(2026, 10));
    expect(scope.read(reportRangeDraftProvider)!.month, DateTime(2026, 10));
    controller.moveMonth(DateTime(2025, 12));
    expect(scope.read(reportRangeDraftProvider)!.month, DateTime(2026, 10));
    controller.moveMonth(DateTime(2027));
    expect(scope.read(reportRangeDraftProvider)!.month, DateTime(2026, 10));
    controller.reset();
    expect(scope.read(reportRangeDraftProvider)!.start, isNull);
    expect(scope.read(reportRangeDraftProvider)!.canApply, isFalse);
  });
}
