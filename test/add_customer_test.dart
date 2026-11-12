import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/features/transactions/pages/customer_picker_sheet.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('add customer validates, detects duplicate and can use it', (tester) async {
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.text('Belum ada pelanggan'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: find.byType(CustomerPickerSheet), matching: find.byType(TextField)),
      'tidak ada',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah pelanggan baru'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama wajib diisi.'), findsOneWidget);
    expect(find.text('Nomor WhatsApp tidak valid.'), findsNothing);

    final fields = find.descendant(
      of: find.byType(AddCustomerSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), 'Budi Baru');
    await tester.enterText(fields.at(1), '0813-7788-1122');
    await tester.tap(find.text('Simpan pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Nomor ini sudah terdaftar atas nama Pak Dedi Budiarto.'), findsOneWidget);
    await tester.tap(find.text('Pakai pelanggan ini'));
    await tester.pumpAndSettle();
    expect(find.text('Pak Dedi Budiarto'), findsOneWidget);
  });

  testWidgets('contact picker fills the add customer form and saves', (tester) async {
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.text('Impor kontak'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agus Pratama'));
    await tester.pumpAndSettle();
    expect(find.text('Agus Pratama'), findsOneWidget);
    expect(find.text('Ambil dari kontak HP'), findsNothing);
    await tester.tap(find.text('Simpan pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Agus Pratama'), findsOneWidget);
  });
}
