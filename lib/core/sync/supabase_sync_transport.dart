import 'package:laurum/core/sync/supabase_sync_wire.dart';
import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';
import 'package:laurum/core/sync/sync_pull_transport.dart';
import 'package:laurum/core/sync/sync_push_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';
import 'package:laurum/core/sync/sync_transport.dart';
import 'package:laurum/core/sync/sync_transport_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSyncTransport implements SyncTransport, SyncPullTransport {
  SupabaseSyncTransport(this.client);
  final SupabaseClient client;

  @override
  Future<SyncPushResult> push(SyncPushRequest request) => _guard(() async {
    final data = await client.rpc<dynamic>('sync_push', params: request.toJson());
    return parseSyncPushResult(data);
  });

  @override
  Future<SyncPullPage> pull(SyncPullRequest request) => _guard(() async {
    final data = await client.rpc<dynamic>('sync_pull', params: request.toJson());
    return parseSyncPullPage(request, data);
  });

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on SyncTransportException {
      rethrow;
    } catch (error) {
      throw _safeError(error);
    }
  }

  SyncTransportException _safeError(Object error) {
    if (error is PostgrestException) {
      if (_safeCodes.contains(error.message)) return SyncTransportException(error.message);
      return SyncTransportException(error.code == '42501' ? 'not_allowed' : 'request_rejected');
    }
    if (error is AuthException) return const SyncTransportException('authentication_required');
    return const SyncTransportException('network_failure');
  }
}

const _safeCodes = {
  'schema_too_old',
  'authentication_required',
  'group_id_required',
  'invalid_group_hash',
  'invalid_fragment',
  'fragment_hash_mismatch',
  'fragment_mismatch',
  'batch_too_large',
  'changes_must_be_nonempty_array',
  'duplicate_change',
  'invalid_change',
  'invalid_payload',
  'unknown_field',
  'table_not_allowed',
  'group_mismatch',
  'group_too_large',
  'group_hash_mismatch',
};
