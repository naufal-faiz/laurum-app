import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/sync/data/sync_fixtures.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final name in [
    'auth_signin',
    'auth_signin_error',
    'sync_saved',
    'sync_saving',
    'sync_offline',
    'sync_failed',
  ]) {
    testWidgets('$name golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final signin = name.startsWith('auth');
      final sync = FakeSyncService(
        initialStatus: switch (name) {
          'sync_saving' => SyncServiceStatus.menyimpan,
          'sync_offline' => SyncServiceStatus.offline,
          'sync_failed' => SyncServiceStatus.gagal,
          _ => SyncServiceStatus.tersimpan,
        },
        pendingChanges: name == 'sync_saved' ? 0 : 3,
        lastSyncedAt: dummyLastSync,
      );
      addTearDown(sync.dispose);
      final scope = ProviderContainer(
        overrides: dummyOverrides(
          authService: FakeAuthService(
            isSignedIn: !signin,
            signInSucceeds: name != 'auth_signin_error',
          ),
          syncService: sync,
        ),
      );
      await pumpAntrean(
        tester,
        container: scope,
        location: signin ? '/masuk' : '/lainnya/sinkronisasi',
      );
      if (name == 'auth_signin_error') {
        await tester.ensureVisible(find.text('Lanjutkan dengan Google'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Lanjutkan dengan Google'));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('antrean-golden')),
        matchesGoldenFile('goldens/$name.png'),
      );
    });
  }
  for (final signin in [true, false]) {
    testWidgets('${signin ? 'signin' : 'sync'} 320px 2x text', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final scope = ProviderContainer(
        overrides: dummyOverrides(authService: FakeAuthService(isSignedIn: !signin)),
      );
      await pumpAntrean(
        tester,
        container: scope,
        location: signin ? '/masuk' : '/lainnya/sinkronisasi',
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
