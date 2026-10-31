import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_period.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  final now = DateTime(2026, 10, 31, 15);
  test('inclusive same-day selection becomes a half-open domain day', () {
    final range = selectedReportRange(DateTime(2026, 10, 16, 8), DateTime(2026, 10, 16, 20), now);
    expect(range.start, DateTime(2026, 10, 16));
    expect(range.end, DateTime(2026, 10, 17));
    expect(range.contains(DateTime(2026, 10, 16, 23, 59)), isTrue);
    expect(range.contains(DateTime(2026, 10, 17)), isFalse);
    expect(reportPeriodRange(3, now, custom: range), range);
  });
  test('bounds reject before 2026, after today, reversed and UTC dates', () {
    for (final pair in [
      (DateTime(2025, 12, 31), DateTime(2026)),
      (now, DateTime(2026, 11)),
      (now, DateTime(2026, 10, 30)),
      (DateTime.utc(2026, 10, 16), DateTime(2026, 10, 16)),
    ]) {
      expect(() => selectedReportRange(pair.$1, pair.$2, now), throwsArgumentError);
    }
    expect(selectedReportRange(DateTime(2026), now, now).end, DateTime(2026, 11));
    expect(() => reportPeriodRange(3, now), throwsStateError);
  });
  test('range labels show inclusive endpoints including year changes', () {
    expect(Formatters.rentangTanggal(DateTime(2026, 10, 12), DateTime(2026, 10, 18)), '12-18 Okt');
    expect(Formatters.rentangTanggal(now, now), '31 Okt');
    expect(Formatters.rentangTanggal(DateTime(2026, 9, 30), DateTime(2026, 10, 2)), '30 Sep-2 Okt');
    expect(
      Formatters.rentangTanggal(DateTime(2026, 12, 31), DateTime(2027)),
      '31 Des 2026-1 Jan 2027',
    );
  });
}
