import 'package:laurum/core/sync/sync_pull_cursor.dart';
import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_transport_exception.dart';

SyncPushResult parseSyncPushResult(Object? raw) {
  if (raw is! Map) throw const SyncTransportException('invalid_response');
  final groupId = raw['group_id'];
  if (groupId is! String) throw const SyncTransportException('invalid_response');
  final status = switch (raw['status']) {
    'committed' => SyncGroupStatus.committed,
    'rejected' => SyncGroupStatus.rejected,
    'staged' => SyncGroupStatus.staged,
    _ => throw const SyncTransportException('invalid_response'),
  };
  final results = <SyncChangeResult>[];
  final rawResults = raw['results'];
  if (rawResults is List) {
    for (final item in rawResults) {
      if (item is! Map || item['change_id'] is! String) {
        throw const SyncTransportException('invalid_response');
      }
      results.add(
        SyncChangeResult(
          changeId: item['change_id'] as String,
          status: item['status'] as String? ?? '',
          code: item['code'] as String?,
        ),
      );
    }
  }
  return SyncPushResult(
    groupId: groupId,
    status: status,
    code: raw['code'] as String?,
    results: results,
    received: _asInt(raw['received']),
    expected: _asInt(raw['expected']),
  );
}

SyncPullPage parseSyncPullPage(SyncPullRequest request, Object? raw) {
  if (raw is! Map || raw['table'] != request.table) {
    throw const SyncTransportException('invalid_response');
  }
  final rawRows = raw['rows'];
  if (rawRows is! List) throw const SyncTransportException('invalid_response');
  final rows = <Map<String, Object?>>[];
  for (final item in rawRows) {
    if (item is! Map) throw const SyncTransportException('invalid_response');
    rows.add({for (final entry in item.entries) entry.key.toString(): entry.value});
  }
  return SyncPullPage(
    table: request.table,
    rows: rows,
    nextCursor: _cursor(raw['next_cursor']),
    hasMore: raw['has_more'] == true,
  );
}

SyncCursor _cursor(Object? raw) {
  if (raw == null) return const SyncCursor();
  if (raw is! Map) throw const SyncTransportException('invalid_response');
  final updatedAt = raw['updated_at'];
  final id = raw['id'];
  if (updatedAt != null && updatedAt is! String) {
    throw const SyncTransportException('invalid_response');
  }
  if (id != null && id is! String) throw const SyncTransportException('invalid_response');
  return SyncCursor(
    updatedAt: updatedAt == null ? null : DateTime.parse(updatedAt as String).toUtc(),
    id: id as String?,
  );
}

int? _asInt(Object? value) => value is num ? value.toInt() : null;
