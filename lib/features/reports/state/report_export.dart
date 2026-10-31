import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';

String reportCsv(ReportView data, {ReportOrdersData? orders}) {
  final t = data.totals;
  final rows = <List<Object>>[
    [
      'Laporan',
      data.period == 3
          ? Formatters.rentangTanggal(
              data.range.start,
              data.range.end.subtract(const Duration(days: 1)),
            )
          : reportPeriodLabels[data.period],
    ],
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
    if (orders != null) ...[
      ['Nomor nota', 'Tanggal', 'Pelanggan', 'Total', 'Status bayar'],
      for (final order in filterReportOrders(orders, filter: 0, search: '', range: data.range))
        [
          order.orderNo,
          Formatters.tanggal(order.enteredAt, ringkas: true),
          orders.customer(order.customerId),
          order.total,
          _payLabel(orders, order),
        ],
    ],
  ];
  return '\uFEFF${rows.map((row) => row.map(_csvCell).join(';')).join('\r\n')}\r\n';
}

String _payLabel(ReportOrdersData data, Order order) => switch (data.paymentStatus(order)) {
  PayStatus.belumBayar => 'Belum bayar',
  PayStatus.dp => 'DP ${data.paid(order)}',
  PayStatus.lunas => 'Lunas',
};

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

  Future<void> export(ReportView data, {ReportOrdersData? orders}) async {
    if (state.busy) return;
    final service = ref.read(exportServiceProvider);
    state = (busy: true, failed: false, message: null);
    try {
      final fileName = data.period == 3
          ? 'laporan-${Formatters.tanggalBerkas(data.range.start)}-'
                '${Formatters.tanggalBerkas(data.range.end.subtract(const Duration(days: 1)))}.csv'
          : 'laporan-${data.period}.csv';
      await service.exportReport(
        fileName: fileName,
        content: reportCsv(data, orders: orders),
      );
      state = (busy: false, failed: false, message: 'Laporan siap diekspor.');
    } catch (_) {
      state = (busy: false, failed: true, message: 'Ekspor gagal. Coba lagi.');
    }
  }
}

final reportExportProvider = NotifierProvider<ReportExport, ReportExportState>(ReportExport.new);
