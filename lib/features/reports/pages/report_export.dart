import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/reports/pages/report_period.dart';
import 'package:laurum/features/reports/pages/report_view.dart';

String reportCsv(ReportView data) {
  final t = data.totals;
  final rows = <List<Object>>[
    ['Laporan', reportPeriodLabels[data.period]],
    ['Mulai', Formatters.tanggal(data.range.start, ringkas: true)],
    ['Sampai', Formatters.tanggal(data.range.end.subtract(const Duration(days: 1)), ringkas: true)],
    ['Pendapatan', t.revenue],
    ['Transaksi', t.transactionCount],
    ['Pengeluaran', t.expenses],
    ['Estimasi laba bersih', t.profit],
    ['Kas masuk', t.cashIn],
    ['Tabungan pelanggan', t.savingsBalance],
    ['Piutang aktif', t.activeOutstanding],
    ['Nota belum lunas', data.unpaidCount],
    if (data.daily != null) ...[
      ['Hari', 'Pendapatan'],
      for (var i = 0; i < data.daily!.length; i++) [data.dayLabels[i], data.daily![i] ?? ''],
    ],
    if (data.services != null) ...[
      ['Layanan', 'Pendapatan'],
      for (final service in data.services!) [service.serviceName, service.revenue],
    ],
  ];
  return '\uFEFF${rows.map((row) => row.map(_csvCell).join(';')).join('\r\n')}\r\n';
}

String _csvCell(Object value) {
  if (value is int) return '$value';
  var text = '$value';
  if (RegExp(r'^[\s]*[=+@-]').hasMatch(text)) text = "'$text";
  return '"${text.replaceAll('"', '""')}"';
}

typedef ReportExportState = ({bool busy, bool failed, String? message});

class ReportExport extends Notifier<ReportExportState> {
  @override
  ReportExportState build() => (busy: false, failed: false, message: null);
  void reset() {
    if (!state.busy) state = build();
  }

  Future<void> export(ReportView data) async {
    if (state.busy) return;
    final service = ref.read(exportServiceProvider);
    state = (busy: true, failed: false, message: null);
    try {
      await service.exportReport(fileName: 'laporan-${data.period}.csv', content: reportCsv(data));
      state = (busy: false, failed: false, message: 'Laporan siap diekspor.');
    } catch (_) {
      state = (busy: false, failed: true, message: 'Ekspor gagal. Coba lagi.');
    }
  }
}

final reportExportProvider = NotifierProvider<ReportExport, ReportExportState>(ReportExport.new);
