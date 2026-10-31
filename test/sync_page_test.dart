import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('sync indicator also follows service in standalone root pages', (tester) async {
    final sync = FakeSyncService(initialStatus: SyncServiceStatus.offline);
    addTearDown(sync.dispose);
    final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
    final host = await pumpAntrean(tester, container: scope, location: '/lainnya/ai');
    for (final path in ['/lainnya/ai', '/lainnya/ai/riwayat', '/lainnya/pengeluaran']) {
      host.router.go(path);
      await tester.pumpAndSettle();
      expect(find.text('Offline'), findsOneWidget);
    }
  });
  testWidgets('sync failure preserves pending changes, successful retry clears them', (
    tester,
  ) async {
    final sync = FakeSyncService(
      pendingChanges: 2,
      succeeds: false,
      clock: () => DateTime(2026, 10, 16, 10, 45),
    );
    addTearDown(sync.dispose);
    final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
    await pumpAntrean(tester, container: scope, location: '/lainnya/sinkronisasi');
    expect(find.text('2 perubahan tertunda'), findsOneWidget);
    await tester.tap(find.text('Sinkron sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Gagal sinkron'), findsOneWidget);
    expect(sync.pendingChanges, 2);
    sync.succeeds = true;
    await tester.tap(find.text('Sinkron sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan'), findsOneWidget);
    expect(find.text('0 perubahan tertunda'), findsOneWidget);
    expect(find.textContaining('10.45 WIB'), findsOneWidget);
  });
  testWidgets('offline banner and indicator share service state; data stays accessible', (
    tester,
  ) async {
    final sync = FakeSyncService(initialStatus: SyncServiceStatus.offline, pendingChanges: 3);
    addTearDown(sync.dispose);
    final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
    final host = await pumpAntrean(tester, container: scope);
    expect(
      find.text('Mode offline. Data tersimpan di HP dan disinkronkan otomatis.'),
      findsOneWidget,
    );
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Semua 12'), findsOneWidget);
    host.router.go('/lainnya/sinkronisasi');
    await tester.pumpAndSettle();
    expect(
      find.text('Mode offline. Data tersimpan di HP dan disinkronkan otomatis.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Sinkron sekarang'));
    await tester.pumpAndSettle();
    expect(sync.pendingChanges, 3);
  });
}
