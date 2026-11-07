import 'package:laurum/core/sync/sync_pull_page.dart';
import 'package:laurum/core/sync/sync_pull_request.dart';

abstract interface class SyncPullTransport {
  Future<SyncPullPage> pull(SyncPullRequest request);
}
