import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('savings history shows counts, filters and immutable note', (tester) async {
    await pumpAntrean(tester, location: '/pelanggan/cust-001/tabungan');
    final list = find.byType(ListView);
    expect(find.text('Pak Dedi Budiarto'), findsOneWidget);
    expect(find.text('Pelanggan Aktif'), findsOneWidget);
    expect(find.text('Saldo tabungan saat ini'), findsOneWidget);
    expect(find.text('Pengembalian'), findsNothing);
    expect(find.text('Terverifikasi'), findsNothing);
    await tester.dragUntilVisible(find.text('Semua (3)'), list, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.text('Setoran (2)'), findsOneWidget);
    expect(find.text('Terpakai (1)'), findsOneWidget);
    await tester.tap(find.text('Terpakai (1)'));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.text('Dipakai nota A-0115'), list, const Offset(0, -200));
    expect(find.text('Setoran tunai'), findsNothing);
    expect(find.text('-Rp25.000'), findsOneWidget);
    expect(find.text('A-0115'), findsWidgets);
    await tester.dragUntilVisible(
      find.text('Riwayat mutasi tidak dapat diubah atau dihapus.'),
      list,
      const Offset(0, -200),
    );
    expect(find.text('Riwayat mutasi tidak dapat diubah atau dihapus.'), findsOneWidget);
  });

  testWidgets('customer without mutations sees the empty state', (tester) async {
    await pumpAntrean(tester, location: '/pelanggan/cust-003/tabungan');
    final list = find.byType(ListView);
    await tester.dragUntilVisible(
      find.text('Belum ada mutasi tabungan'),
      list,
      const Offset(0, -200),
    );
    expect(find.text('Belum ada mutasi tabungan'), findsOneWidget);
    expect(find.text('Setoran dan pemakaian saldo akan tampil di sini.'), findsOneWidget);
    expect(find.text('Setor tabungan'), findsOneWidget);
  });
}
