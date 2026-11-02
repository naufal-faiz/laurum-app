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
    expect(find.text('COD 0'), findsOneWidget);
    expect(find.text('Sebagian 5'), findsOneWidget);
    expect(find.text('A-0128'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('Catat bayar'), findsWidgets);
    expect(find.text('Ingatkan'), findsNothing);
    expect(
      find.text('Piutang tidak dapat dihapus; catat pembayaran untuk mengurangi sisa tagihan.'),
      findsOneWidget,
    );
  });

  testWidgets('non-COD filter includes the legacy outstanding notes', (tester) async {
    await pumpAntrean(tester, location: '/laporan/piutang');
    await tester.tap(find.text('Sebagian 5'));
    await tester.pumpAndSettle();
    expect(find.text('A-0128'), findsOneWidget);
    expect(find.text('A-0136'), findsOneWidget);
    expect(find.text('A-0140'), findsOneWidget);
    expect(find.text('A-0138'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
  });
}
