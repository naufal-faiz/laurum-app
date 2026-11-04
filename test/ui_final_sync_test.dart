import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final status in [SyncServiceStatus.offline, SyncServiceStatus.gagal]) {
    testWidgets('main tabs expose $status banner and preserve local changes', (tester) async {
      final sync = FakeSyncService(initialStatus: status, pendingChanges: 3);
      addTearDown(sync.dispose);
      final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
      final host = await pumpAntrean(tester, container: scope, textScale: 1.3);
      for (final path in ['/antrean', '/pelanggan', '/laporan', '/lainnya']) {
        host.router.go(path);
        await tester.pumpAndSettle();
        expect(
          find.text(
            status == SyncServiceStatus.offline
                ? 'Mode offline. Data tersimpan di HP dan disinkronkan otomatis.'
                : 'Sinkronisasi gagal. Data di HP tetap tersimpan.',
          ),
          findsOneWidget,
        );
        expect(sync.pendingChanges, 3);
        expect(tester.takeException(), isNull);
      }
    });
  }
}
