import 'package:laurum/core/sync/sync_pull_cursor.dart';

class SyncPullRequest {
  const SyncPullRequest({
    required this.table,
    this.cursor = const SyncCursor(),
    this.limit = 500,
  }) : assert(limit > 0 && limit <= 500);

  final String table;
  final SyncCursor cursor;
  final int limit;

  Map<String, Object?> toJson() => {
    'p_table': table,
    'p_cursor_updated_at': cursor.updatedAt?.toUtc().toIso8601String(),
    'p_cursor_id': cursor.id,
    'p_limit': limit,
  };
}
