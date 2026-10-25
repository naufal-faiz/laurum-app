import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/export_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/reports/state/report_export.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/main_dummy.dart';

class RetryExportService extends FakeExportService {
  bool fail = true;
  @override
  Future<String> exportReport({required String fileName, required String content}) {
    if (fail) {
      fail = false;
      throw StateError('test export failure');
    }
    return super.exportReport(fileName: fileName, content: content);
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('export failure preserves retry and includes period/chart/services', () async {
    final service = RetryExportService();
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        exportServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(scope.dispose);
    final data = await scope.read(reportViewProvider.future);
    final exporter = scope.read(reportExportProvider.notifier);
    await exporter.export(data);
    expect(scope.read(reportExportProvider).failed, isTrue);
    expect(scope.read(reportExportProvider).busy, isFalse);
    await exporter.export(data);
    expect(scope.read(reportExportProvider).failed, isFalse);
    expect(service.exportedReports, hasLength(1));
    final content = service.exportedReports.single.content;
    expect(content, contains('"Laporan";"Minggu ini"'));
    expect(content, contains('"Jum";375000'));
    expect(content, contains('"Sab";""'));
    expect(content, contains('"Cuci setrika";882000'));
    expect(content, contains('"Tabungan pelanggan";430000'));
  });
}
