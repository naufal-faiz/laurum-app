import 'package:laurum/core/sync/sync_pull_cursor.dart';

class SyncPullPage {
  const SyncPullPage({
    required this.table,
    required this.rows,
    required this.nextCursor,
    required this.hasMore,
  });

  final String table;
  final List<Map<String, Object?>> rows;
  final SyncCursor nextCursor;
  final bool hasMore;
}
