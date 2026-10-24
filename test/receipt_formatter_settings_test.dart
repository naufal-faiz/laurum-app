import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';

import 'receipt_fixtures.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('settings hide optional receipt elements', () {
    final lines = receiptLines(
      business: receiptBusiness(),
      order: receiptOrder(),
      items: receiptItems,
      payments: receiptPayments(),
      customerName: 'Pak Dedi',
      settings: receiptSettings(
        showAddress: false,
        showCustomer: false,
        showSavings: false,
        showNote: false,
      ),
      savingsBalance: 50000,
    );
    expect(lines.where((line) => line.contains('Melati')), isEmpty);
    expect(lines.where((line) => line.startsWith('Pelanggan')), isEmpty);
    expect(lines.where((line) => line.startsWith('Catatan')), isEmpty);
    expect(lines.where((line) => line.startsWith('Tabungan dipakai')), isEmpty);
    expect(lines, contains('STATUS: LUNAS'));
  });
}
