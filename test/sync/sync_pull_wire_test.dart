import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/supabase_sync_wire.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_transport_exception.dart';

void main() {
  test('parses a committed receipt with per-change results', () {
    final result = parseSyncPushResult({
      'group_id': '11111111-1111-4111-8111-111111111111',
      'status': 'committed',
      'results': [
        {
          'change_id': '22222222-2222-4222-8222-222222222222',
          'table': 'customers',
          'row_id': '33333333-3333-4333-8333-333333333333',
          'status': 'ok',
          'updated_at': '2026-11-06T06:29:12.123456Z',
        },
      ],
    });
    expect(result.status, SyncGroupStatus.committed);
    expect(result.acknowledged, {'22222222-2222-4222-8222-222222222222'});
    expect(result.results.single.status, 'ok');
  });

  test('parses a rejected receipt without exposing SQL messages', () {
    final result = parseSyncPushResult({
      'group_id': '11111111-1111-4111-8111-111111111111',
      'status': 'rejected',
      'code': 'unique_conflict',
      'results': [
        {'change_id': '22222222-2222-4222-8222-222222222222', 'status': 'ditolak'},
      ],
    });
    expect(result.status, SyncGroupStatus.rejected);
    expect(result.code, 'unique_conflict');
    expect(result.acknowledged, isEmpty);
  });

  test('parses staged fragments and rejects malformed payloads', () {
    final staged = parseSyncPushResult({
      'group_id': '11111111-1111-4111-8111-111111111111',
      'status': 'staged',
      'received': 1,
      'expected': 3,
      'results': <Object?>[],
    });
    expect(staged.received, 1);
    expect(staged.expected, 3);
    expect(
      () => parseSyncPushResult({'group_id': 'x', 'status': 'unknown'}),
      throwsA(isA<SyncTransportException>()),
    );
  });

  test('parses a pull page with cursor and tombstone row', () {
    const request = SyncPullRequest(table: 'customers');
    final page = parseSyncPullPage(request, {
      'table': 'customers',
      'rows': [
        {
          'id': '33333333-3333-4333-8333-333333333333',
          'owner_id': '11111111-1111-4111-8111-111111111111',
          'name': 'Sari',
          'deleted_at': '2026-11-06T06:29:12.123456Z',
        },
      ],
      'next_cursor': {
        'updated_at': '2026-11-06T06:29:12.123456Z',
        'id': '33333333-3333-4333-8333-333333333333',
      },
      'has_more': true,
    });
    expect(page.rows.single['name'], 'Sari');
    expect(page.nextCursor.updatedAt, DateTime.utc(2026, 11, 6, 6, 29, 12, 123, 456));
    expect(page.hasMore, isTrue);
  });

  test('a pull response for another table or a bad cursor is rejected', () {
    const request = SyncPullRequest(table: 'orders');
    expect(
      () => parseSyncPullPage(request, {
        'table': 'customers',
        'rows': <Object?>[],
        'has_more': false,
      }),
      throwsA(isA<SyncTransportException>()),
    );
    expect(
      () => parseSyncPullPage(request, {
        'table': 'orders',
        'rows': <Object?>[],
        'next_cursor': {'updated_at': 12, 'id': null},
        'has_more': false,
      }),
      throwsA(isA<SyncTransportException>()),
    );
  });
}
