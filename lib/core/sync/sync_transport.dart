import 'package:laurum/core/sync/sync_push_request.dart';
import 'package:laurum/core/sync/sync_push_result.dart';

abstract interface class SyncTransport {
  Future<SyncPushResult> push(SyncPushRequest request);
}
