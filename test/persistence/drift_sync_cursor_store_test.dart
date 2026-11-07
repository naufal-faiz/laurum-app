import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_cursor_store.dart';
import 'package:laurum/core/sync/sync_pull_cursor.dart';

void main() {
  late AppDatabase db;
  late DriftSyncCursorStore store;
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    store = DriftSyncCursorStore(db);
  });
  tearDown(() => db.close());

  test('an unseen table starts at the empty cursor', () async {
    final cursor = await store.read('customers');
    expect(cursor.isEmpty, isTrue);
  });

  test('saves and advances the tuple cursor', () async {
    final first = SyncCursor(
      updatedAt: DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456),
      id: '33333333-3333-4333-8333-333333333333',
    );
    await store.save('customers', first);
    var read = await store.read('customers');
    expect(read.updatedAt, first.updatedAt);
    expect(read.id, first.id);
    final second = SyncCursor(
      updatedAt: DateTime.utc(2026, 11, 6, 7),
      id: '44444444-4444-4444-8444-444444444444',
    );
    await store.save('customers', second);
    read = await store.read('customers');
    expect(read.id, second.id);
    expect(await db.select(db.syncCursorRecords).get(), hasLength(1));
  });

  test('unknown tables are rejected instead of touching SQL', () async {
    await expectLater(store.read('outbox'), throwsArgumentError);
    await expectLater(store.save('sync_cursors', const SyncCursor()), throwsArgumentError);
  });
}
