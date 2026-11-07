import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/in_memory_outbox_store.dart';
import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_coordinator.dart';
import 'package:laurum/core/sync/sync_cursor_store.dart';
import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_group.dart';
import 'package:laurum/core/sync/sync_pull_cursor.dart';
import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:laurum/core/sync/sync_pull_transport.dart';
import 'package:laurum/core/sync/sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_run_result.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

import 'fake_sync_transport.dart';

void main() {
  test('a successful cycle pushes first and then pulls every table', () async {
    final store = InMemoryOutboxStore(groups: [_group()]);
    final pullTransport = _RecordingPullTransport();
    final result = await SyncCoordinator(
      SyncEngine(store, FakeSyncTransport()),
      SyncPullRunner(pullTransport, _MemoryCursors(), _NoopApplier()),
    ).run();
    expect(result.push.status, SyncRunStatus.selesai);
    expect(result.succeeded, isTrue);
    expect(pullTransport.requests.map((r) => r.table), syncPullOrder);
  });

  test('a blocked push never touches the pull transport', () async {
    final store = InMemoryOutboxStore(legacy: [_change()]);
    final pullTransport = _RecordingPullTransport();
    final result = await SyncCoordinator(
      SyncEngine(store, FakeSyncTransport()),
      SyncPullRunner(pullTransport, _MemoryCursors(), _NoopApplier()),
    ).run();
    expect(result.push.status, SyncRunStatus.legacy);
    expect(result.pull, isNull);
    expect(result.succeeded, isFalse);
    expect(pullTransport.requests, isEmpty);
  });
}

SyncGroup _group() => SyncGroup('11111111-1111-4111-8111-111111111111', [_change()]);

SyncChange _change() => const SyncChange(
  changeId: '22222222-2222-4222-8222-222222222222',
  table: 'customers',
  rowId: '33333333-3333-4333-8333-333333333333',
  op: 'upsert',
  payload: {'id': '33333333-3333-4333-8333-333333333333'},
);

class _RecordingPullTransport implements SyncPullTransport {
  final requests = <SyncPullRequest>[];
  @override
  Future<SyncPullPage> pull(SyncPullRequest request) async {
    requests.add(request);
    return SyncPullPage(
      table: request.table,
      rows: const [],
      nextCursor: request.cursor,
      hasMore: false,
    );
  }
}

class _MemoryCursors implements SyncCursorStore {
  final _values = <String, SyncCursor>{};
  @override
  Future<SyncCursor> read(String table) async => _values[table] ?? const SyncCursor();
  @override
  Future<void> save(String table, SyncCursor cursor) async => _values[table] = cursor;
}

class _NoopApplier implements SyncRemoteApplier {
  @override
  Future<void> apply(String table, List<Map<String, Object?>> rows) async {}
}
