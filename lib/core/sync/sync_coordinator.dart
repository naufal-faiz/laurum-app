import 'package:laurum/core/sync/sync_engine.dart';
import 'package:laurum/core/sync/sync_pull_result.dart';
import 'package:laurum/core/sync/sync_pull_runner.dart';
import 'package:laurum/core/sync/sync_run_result.dart';

class SyncCycleResult {
  const SyncCycleResult({required this.push, this.pull});
  final SyncRunResult push;
  final SyncPullResult? pull;

  bool get succeeded => push.succeeded && (pull?.succeeded ?? false);
}

class SyncCoordinator {
  SyncCoordinator(this.pushEngine, this.pullRunner);
  final SyncEngine pushEngine;
  final SyncPullRunner pullRunner;

  Future<SyncCycleResult> run() async {
    final push = await pushEngine.run();
    if (!push.succeeded) return SyncCycleResult(push: push);
    return SyncCycleResult(push: push, pull: await pullRunner.run());
  }
}
