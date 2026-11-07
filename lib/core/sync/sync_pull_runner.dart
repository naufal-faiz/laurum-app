import 'package:laurum/core/sync/sync_cursor_store.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_pull_transport.dart';
import 'package:laurum/core/sync/sync_remote_applier.dart';
import 'package:laurum/core/sync/sync_table_names.dart';
import 'package:laurum/core/sync/sync_transport_exception.dart';

class SyncPullRunner {
  SyncPullRunner(this.transport, this.cursors, this.applier, {this.limit = 500});

  final SyncPullTransport transport;
  final SyncCursorStore cursors;
  final SyncRemoteApplier applier;
  final int limit;

  Future<SyncPullResult> run() async {
    var tables = 0;
    var applied = 0;
    try {
      for (final table in syncPullOrder) {
        var cursor = await cursors.read(table);
        while (true) {
          final page = await transport.pull(
            SyncPullRequest(table: table, cursor: cursor, limit: limit),
          );
          if (page.table != table) throw StateError('Pulled table does not match request');
          if (page.rows.isNotEmpty) await applier.apply(table, page.rows);
          applied += page.rows.length;
          if (page.hasMore && page.nextCursor.samePosition(cursor)) {
            throw StateError('Pull cursor did not advance for $table');
          }
          await cursors.save(table, page.nextCursor);
          cursor = page.nextCursor;
          if (!page.hasMore) break;
        }
        tables++;
      }
    } on SyncTransportException catch (error) {
      return SyncPullResult(
        status: SyncPullStatus.gagal,
        tablesPulled: tables,
        appliedRows: applied,
        code: error.code,
      );
    }
    return SyncPullResult(
      status: SyncPullStatus.selesai,
      tablesPulled: tables,
      appliedRows: applied,
    );
  }
}
