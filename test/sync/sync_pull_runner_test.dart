import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/sync_cursor_store.dart';
import 'package:laurum/core/sync/sync_pull_cursor.dart';
import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:laurum/core/sync/sync_pull_transport.dart';
import 'package:laurum/core/sync/sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_table_names.dart';
import 'package:laurum/core/sync/sync_transport_exception.dart';

void main() {
  test('pulls every table in dependency order and advances cursors page by page', () async {
    final first = SyncCursor(
      updatedAt: DateTime.utc(2026, 11, 6, 6),
      id: '10000000-0000-4000-8000-000000000001',
    );
    final second = SyncCursor(
      updatedAt: DateTime.utc(2026, 11, 6, 7),
      id: '10000000-0000-4000-8000-000000000002',
    );
    final transport = _FakePullTransport({
      'customers': [
        SyncPullPage(table: 'customers', rows: [_row('a')], nextCursor: first, hasMore: true),
        SyncPullPage(table: 'customers', rows: [_row('b')], nextCursor: second, hasMore: true),
        SyncPullPage(table: 'customers', rows: [], nextCursor: second, hasMore: false),
      ],
    });
    final cursors = _MemoryCursors();
    final applier = _RecordingApplier();
    final result = await SyncPullRunner(transport, cursors, applier).run();
    expect(result.status, SyncPullStatus.selesai);
    expect(result.tablesPulled, syncPullOrder.length);
    expect(result.appliedRows, 2);
    expect(transport.requests.map((r) => r.table).toList(), [
      'businesses',
      'customers',
      'customers',
      'customers',
      ...syncPullOrder.skip(2),
    ]);
    expect(applier.tables, ['customers', 'customers']);
    expect(await cursors.read('customers'), second);
  });

  test('a stalled cursor stops instead of looping forever', () async {
    const empty = SyncCursor();
    final transport = _FakePullTransport({
      'customers': [
        SyncPullPage(table: 'customers', rows: [_row('a')], nextCursor: empty, hasMore: true),
      ],
    });
    await expectLater(
      SyncPullRunner(transport, _MemoryCursors(), _RecordingApplier()).run(),
      throwsStateError,
    );
  });

  test('transport errors return a failed result and keep the last good cursor', () async {
    final transport = _FailingPullTransport();
    final cursors = _MemoryCursors();
    final result = await SyncPullRunner(transport, cursors, _RecordingApplier()).run();
    expect(result.status, SyncPullStatus.gagal);
    expect(result.code, 'schema_too_old');
    expect(result.tablesPulled, 1);
    expect((await cursors.read('businesses')).isEmpty, isTrue);
  });
}

Map<String, Object?> _row(String id) => {'id': id, 'owner_id': 'owner'};

class _MemoryCursors implements SyncCursorStore {
  final _values = <String, SyncCursor>{};
  @override
  Future<SyncCursor> read(String table) async => _values[table] ?? const SyncCursor();
  @override
  Future<void> save(String table, SyncCursor cursor) async => _values[table] = cursor;
}

class _RecordingApplier implements SyncRemoteApplier {
  final tables = <String>[];
  @override
  Future<void> apply(String table, List<Map<String, Object?>> rows) async => tables.add(table);
}

class _FakePullTransport implements SyncPullTransport {
  _FakePullTransport(this.pages);
  final Map<String, List<SyncPullPage>> pages;
  final requests = <SyncPullRequest>[];
  final _index = <String, int>{};

  @override
  Future<SyncPullPage> pull(SyncPullRequest request) async {
    requests.add(request);
    final pagesForTable = pages[request.table];
    if (pagesForTable == null) {
      return SyncPullPage(
        table: request.table,
        rows: const [],
        nextCursor: request.cursor,
        hasMore: false,
      );
    }
    final index = _index[request.table] ?? 0;
    _index[request.table] = index + 1;
    return pagesForTable[index];
  }
}

class _FailingPullTransport implements SyncPullTransport {
  @override
  Future<SyncPullPage> pull(SyncPullRequest request) async {
    if (request.table == 'customers') throw const SyncTransportException('schema_too_old');
    return SyncPullPage(
      table: request.table,
      rows: const [],
      nextCursor: request.cursor,
      hasMore: false,
    );
  }
}
