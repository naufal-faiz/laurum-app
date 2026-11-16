import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/customers/state/customer_directory_controller.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/shared/widgets/organisms/app_data_refresh.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final path in [
    '/beranda',
    '/antrean',
    '/pelanggan',
    '/lainnya',
    '/laporan',
    '/lainnya/pengeluaran',
    '/lainnya/layanan',
    '/laporan/piutang',
    '/pelanggan/cust-001',
    '/pelanggan/cust-001/tabungan',
    '/order/ord-0127',
    '/transaksi/nota/ord-0127',
  ]) {
    testWidgets('$path pulls sync without losing filters or scroll position', (tester) async {
      final host = await pumpAntrean(tester, location: path);
      final sync = host.container.read(syncServiceProvider) as FakeSyncService;
      host.container.read(antreanFilterProvider.notifier).select(2);
      host.container.read(customerDirectorySearchProvider.notifier).set('Sari');
      host.container.read(reportPeriodProvider.notifier).select(0);
      await tester.pumpAndSettle();
      expect(find.byType(AppDataRefresh), findsOneWidget);
      final scroll = find
          .descendant(
            of: find.byType(AppDataRefresh),
            matching: find.byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            ),
          )
          .first;
      final calls = sync.syncCallCount;
      await tester.drag(scroll, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(sync.syncCallCount, calls + 1);
      expect(host.container.read(antreanFilterProvider), 2);
      expect(host.container.read(customerDirectorySearchProvider), 'Sari');
      expect(host.container.read(reportPeriodProvider), 0);
      expect(tester.state<ScrollableState>(scroll).position.pixels, 0);
      expect(tester.takeException(), isNull);
    });
  }
  for (final path in [
    '/transaksi/baru',
    '/lainnya/layanan/baru',
    '/lainnya/layanan/srv-001',
    '/order/ord-0127/edit',
  ]) {
    testWidgets('$path leaves editable drafts outside refresh', (tester) async {
      await pumpAntrean(tester, location: path);
      expect(find.byType(AppDataRefresh), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
