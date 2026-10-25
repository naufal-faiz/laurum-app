import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('outstanding list shows five active notes with totals', (tester) async {
    await pumpAntrean(tester, location: '/laporan/piutang');
    expect(
      find.text('Total piutang usaha Rp400.500 / 5 nota belum lunas - 5 pelanggan'),
      findsOneWidget,
    );
    expect(find.text('Semua 5'), findsOneWidget);
    expect(find.text('Belum bayar 2'), findsOneWidget);
    expect(find.text('DP 3'), findsOneWidget);
    expect(find.text('A-0128'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('Catat bayar'), findsWidgets);
    expect(find.text('Ingatkan'), findsWidgets);
    expect(
      find.text('Piutang tidak dapat dihapus; catat bayar atau tandai lunas di kasir.'),
      findsOneWidget,
    );
  });

  testWidgets('filter DP shows only DP notes', (tester) async {
    await pumpAntrean(tester, location: '/laporan/piutang');
    await tester.tap(find.text('DP 3'));
    await tester.pumpAndSettle();
    expect(find.text('A-0128'), findsOneWidget);
    expect(find.text('A-0136'), findsOneWidget);
    expect(find.text('A-0140'), findsOneWidget);
    expect(find.text('A-0138'), findsNothing);
    expect(find.text('A-0142'), findsNothing);
  });
}
