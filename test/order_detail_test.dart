import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/features/reports/data/report_fixtures.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('detail shows stored order, payment and activity without owner', (tester) async {
    final host = await pumpAntrean(tester, location: '/order/ord-0142');
    expect(find.text('Detail order'), findsOneWidget);
    expect(find.text('A-0142'), findsOneWidget);
    expect(find.text('Diproses'), findsOneWidget);
    expect(find.text('Belum bayar'), findsWidgets);
    expect(find.text('Jumat, 16 Okt 2026 10.15 WIB'), findsOneWidget);
    expect(find.text('Minggu, 18 Okt 2026 17.00 WIB'), findsOneWidget);
    expect(find.text('Pak Dedi Budiarto'), findsOneWidget);
    expect(find.text('0813-7788-1122'), findsOneWidget);
    expect(find.text('Jl. Cemara No. 12, RT 03/05'), findsOneWidget);
    expect(find.text('Cuci kiloan'), findsOneWidget);
    expect(find.text('4,5 kg × Rp7.000'), findsOneWidget);
    expect(find.text('Rp31.500'), findsWidgets);
    expect(find.text('Sisa piutang'), findsOneWidget);
    expect(find.text('Jejak aktivitas'), findsOneWidget);
    expect(find.text('Status diubah menjadi Diproses'), findsOneWidget);
    expect(find.text('Order dibuat'), findsOneWidget);
    expect(find.text('Oleh Pemilik'), findsNothing);
    expect(find.text('Tandai siap'), findsOneWidget);
    expect(find.text('Cetak struk'), findsOneWidget);

    final before = (await host.container.read(reportRepositoryProvider).getReport(weekRange));
    await tester.tap(find.text('Tandai siap'));
    await tester.pumpAndSettle();
    final repository = host.container.read(orderRepositoryProvider);
    expect((await repository.getOrderById('ord-0142'))!.status, OrderStatus.siap);
    expect(find.text('Serahkan'), findsOneWidget);
    final data = (await host.container.read(orderDetailProvider('ord-0142').future))!;
    expect(data.activity.first.label, 'Status diubah menjadi Siap');
    final after = await host.container.read(reportRepositoryProvider).getReport(weekRange);
    expect(after.revenue, before.revenue);
  });

  testWidgets('menu cancels the order and removes it from reports', (tester) async {
    final host = await pumpAntrean(tester, location: '/order/ord-0142');
    final reports = host.container.read(reportRepositoryProvider);
    final before = await reports.getReport(weekRange);
    await tester.tap(find.byTooltip('Menu order'));
    await tester.pumpAndSettle();
    expect(find.text('Edit order'), findsOneWidget);
    expect(find.text('Ubah status'), findsOneWidget);
    expect(find.text('Batalkan order'), findsOneWidget);
    await tester.tap(find.text('Batalkan order'));
    await tester.pumpAndSettle();
    expect(find.text('Batalkan order A-0142?'), findsOneWidget);
    expect(
      find.text('Order tidak dihitung di laporan. Riwayatnya tetap tersimpan.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Ya, batalkan order'));
    await tester.pumpAndSettle();
    final order = await host.container.read(orderRepositoryProvider).getOrderById('ord-0142');
    expect(order!.status, OrderStatus.dibatalkan);
    expect(find.text('Dibatalkan'), findsOneWidget);
    expect(find.text('Tandai siap'), findsNothing);
    final after = await reports.getReport(weekRange);
    expect(after.revenue, before.revenue - 31500);
    expect(tester.takeException(), isNull);
  });

  testWidgets('catat pembayaran settles the remaining debt', (tester) async {
    final host = await pumpAntrean(tester, location: '/order/ord-0142');
    await tester.ensureVisible(find.text('Catat pembayaran'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Catat pembayaran'));
    await tester.pumpAndSettle();
    expect(find.text('Sisa piutang Rp31.500'), findsOneWidget);
    await tester.tap(find.text('Simpan pembayaran'));
    await tester.pumpAndSettle();
    final data = (await host.container.read(orderDetailProvider('ord-0142').future))!;
    expect(data.paid, 31500);
    expect(data.outstanding, 0);
    expect(find.text('Lunas'), findsWidgets);
    expect(find.text('Rp0'), findsOneWidget);
  });
}
