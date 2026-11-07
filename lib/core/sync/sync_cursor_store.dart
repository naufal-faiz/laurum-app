import 'package:laurum/core/sync/sync_pull_cursor.dart';

abstract interface class SyncCursorStore {
  Future<SyncCursor> read(String table);
  Future<void> save(String table, SyncCursor cursor);
}
