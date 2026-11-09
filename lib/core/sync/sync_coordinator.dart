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

/// One push-then-pull pass. Implemented by [SyncCoordinator] and by fakes so
/// the sync scheduler can run without a network or database.
abstract interface class SyncCycle {
  Future<SyncCycleResult> run();
}

class SyncCoordinator implements SyncCycle {
  SyncCoordinator(this.pushEngine, this.pullRunner);
  final SyncEngine pushEngine;
  final SyncPullRunner pullRunner;

  @override
  Future<SyncCycleResult> run() async {
    final push = await pushEngine.run();
    if (!push.succeeded) return SyncCycleResult(push: push);
    return SyncCycleResult(push: push, pull: await pullRunner.run());
  }
}
