import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('pending logout warns and cancel preserves session', (tester) async {
    final sync = FakeSyncService(pendingChanges: 3);
    addTearDown(sync.dispose);
    final scope = ProviderContainer(overrides: dummyOverrides(syncService: sync));
    await pumpAntrean(tester, container: scope, location: '/lainnya');
    await tester.ensureVisible(find.text('Keluar'));
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('3 perubahan belum tersinkron'), findsOneWidget);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(scope.read(authServiceProvider).isSignedIn, isTrue);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar').last);
    await tester.pumpAndSettle();
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
    expect(sync.pendingChanges, 3);
  });
  testWidgets('delete requires both confirmations and clears data only on final yes', (
    tester,
  ) async {
    final host = await pumpAntrean(tester, location: '/lainnya');
    final button = find.text('Hapus akun');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Hapus akun?'), findsOneWidget);
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus akun secara permanen?'), findsOneWidget);
    expect(host.container.read(authServiceProvider).isSignedIn, isTrue);
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();
    expect(host.container.read(authServiceProvider).isSignedIn, isTrue);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus permanen'));
    await tester.pumpAndSettle();
    expect(host.container.read(authServiceProvider).isSignedIn, isFalse);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);
  });
}
