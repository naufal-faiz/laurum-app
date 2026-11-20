import 'package:laurum/core/sync/sync_pull_cursor.dart';
import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_pull_transport.dart';
import 'package:laurum/core/sync/sync_push_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_table_names.dart';

import '../persistence/sync_wire_rows.dart';
import 'fake_sync_transport.dart';

// Protocol-valid fake server shared by two independent SQLite devices.
class RefreshMemoryServer extends FakeSyncTransport implements SyncPullTransport {
  RefreshMemoryServer(String owner) {
    final rows = allWireRows();
    for (var i = 0; i < syncPullOrder.length; i++) {
      tables[syncPullOrder[i]] = {...rows[i], 'owner_id': owner};
    }
  }
  final tables = <String, Map<String, Object?>>{};
  int pulls = 0;
  @override
  Future<SyncPushResult> push(SyncPushRequest request) async {
    final result = await super.push(request);
    if (result.status == SyncGroupStatus.committed) {
      for (final change in request.changes) {
        tables[change.table] = {...?tables[change.table], ...change.payload};
      }
    }
    return result;
  }

  @override
  Future<SyncPullPage> pull(SyncPullRequest request) async {
    pulls++;
    final row = tables[request.table]!;
    return SyncPullPage(
      table: request.table,
      rows: [row],
      nextCursor: SyncCursor(
        updatedAt: DateTime.parse(row['updated_at']! as String),
        id: row['id']! as String,
      ),
      hasMore: false,
    );
  }
}
