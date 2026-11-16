import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/data_refresh_failure.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/sync/state/data_refresh_actions.dart';
import 'package:laurum/features/sync/state/data_refresh_queries.dart';

import 'held_refresh_sync.dart';

void main() {
  test('concurrent refreshes share sync, merge queries and await reloaded data', () async {
    final sync = HeldRefreshSync();
    addTearDown(sync.dispose);
    var reads = 0, extraReads = 0;
    Completer<int>? reload;
    final query = FutureProvider<int>((ref) {
      reads++;
      return reload?.future ?? Future.value(1);
    });
    final extra = FutureProvider<int>((ref) async => ++extraReads);
    final scope = ProviderContainer(
      overrides: [
        syncServiceProvider.overrideWithValue(sync),
        dataRefreshQueriesProvider.overrideWithValue([query.future]),
      ],
    );
    addTearDown(scope.dispose);
    expect(await scope.read(query.future), 1);
    reload = Completer<int>();
    final actions = scope.read(dataRefreshActionsProvider.notifier);
    var finished = false;
    final first = actions.refresh().then((_) => finished = true);
    final second = actions.refresh(extra: [extra.future]);
    expect(sync.requests, 1);
    expect(reads, 1);
    sync.gate.complete();
    await pumpEventQueue();
    expect(reads, 2);
    expect(finished, isFalse);
    reload.complete(2);
    await Future.wait([first, second]);
    expect(await scope.read(query.future), 2);
    expect(extraReads, 1);
    expect(sync.requests, 1);
    reload = null;
    await actions.refresh();
    expect(sync.requests, 2);
  });

  for (final failure in DataRefreshFailure.values) {
    test('$failure reports safely and preserves cached local data', () async {
      final sync = HeldRefreshSync()..ready = failure != DataRefreshFailure.notReady;
      if (failure == DataRefreshFailure.offline) sync.setConnection(online: false);
      sync.succeeds = failure != DataRefreshFailure.failed;
      sync.gate.complete();
      addTearDown(sync.dispose);
      var reads = 0;
      final query = FutureProvider<int>((ref) async => ++reads);
      final scope = ProviderContainer(
        overrides: [
          syncServiceProvider.overrideWithValue(sync),
          dataRefreshQueriesProvider.overrideWithValue([query.future]),
        ],
      );
      addTearDown(scope.dispose);
      expect(await scope.read(query.future), 1);
      await expectLater(
        scope.read(dataRefreshActionsProvider.notifier).refresh(),
        throwsA(failure),
      );
      expect(await scope.read(query.future), 1);
      expect(reads, 1);
    });
  }

  test('a late refresh does not query a replacement account or disposed scope', () async {
    for (final dispose in [false, true]) {
      final old = HeldRefreshSync(), next = FakeSyncService();
      var reads = 0;
      final query = FutureProvider<int>((ref) async => ++reads);
      final scope = ProviderContainer(
        overrides: [
          syncServiceProvider.overrideWithValue(old),
          dataRefreshQueriesProvider.overrideWithValue([query.future]),
        ],
      );
      final work = scope.read(dataRefreshActionsProvider.notifier).refresh();
      if (dispose) {
        scope.dispose();
      } else {
        scope.updateOverrides([
          syncServiceProvider.overrideWithValue(next),
          dataRefreshQueriesProvider.overrideWithValue([query.future]),
        ]);
      }
      old.gate.complete();
      await work;
      expect(reads, 0);
      if (!dispose) scope.dispose();
      old.dispose();
      next.dispose();
    }
  });
}
