import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';

import 'receipt_fixtures.dart';
import 'receipt_template_lines.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('A-0143 matches the receipt template', () {
    final lines = receiptLines(
      business: receiptBusiness(),
      order: receiptOrder(),
      items: receiptItems,
      payments: receiptPayments(),
      customerName: 'Pak Dedi',
      settings: receiptSettings(),
      savingsBalance: 50000,
    );
    expect(lines, receiptTemplateLines);
    expect(lines.every((line) => line.length <= receiptColumns), isTrue);
    expect(lines.firstWhere((line) => line.startsWith('TOTAL')).length, receiptColumns);
  });

  test('tabungan-only payment is LUNAS (TABUNGAN) and keeps the remainder', () {
    final lines = receiptLines(
      business: receiptBusiness(),
      order: receiptOrder(note: ''),
      items: receiptItems,
      payments: [receiptPayment('p1', PayMethod.tabungan, 56500)],
      customerName: 'Pak Dedi',
      settings: receiptSettings(),
      savingsBalance: 60000,
    );
    expect(lines, contains('STATUS: LUNAS (TABUNGAN)'));
    expect(
      lines.any((line) => line.startsWith('Sisa tabungan') && line.endsWith('Rp3.500')),
      isTrue,
    );
    expect(lines.where((line) => line.startsWith('Catatan:')), isEmpty);
  });

  test('partial payment is DP and unpaid order is BELUM BAYAR', () {
    final dp = receiptLines(
      business: receiptBusiness(),
      order: receiptOrder(note: ''),
      items: receiptItems,
      payments: [receiptPayment('p1', PayMethod.qris, 10000)],
      customerName: 'Pak Dedi',
      settings: receiptSettings(),
    );
    final unpaid = receiptLines(
      business: receiptBusiness(),
      order: receiptOrder(note: ''),
      items: receiptItems,
      payments: const [],
      customerName: 'Pak Dedi',
      settings: receiptSettings(),
    );
    expect(dp, contains('STATUS: DP Rp10.000'));
    expect(
      dp.any((line) => line.startsWith('Dibayar QRIS') && line.endsWith('Rp10.000')),
      isTrue,
    );
    expect(unpaid, contains('STATUS: BELUM BAYAR'));
    expect(unpaid.where((line) => line.startsWith('Tabungan dipakai')), isEmpty);
  });
}
