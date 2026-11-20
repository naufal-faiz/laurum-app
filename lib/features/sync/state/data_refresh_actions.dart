import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/data_refresh_failure.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/sync/state/data_refresh_queries.dart';

final dataRefreshActionsProvider = NotifierProvider<DataRefreshActions, void>(
  DataRefreshActions.new,
);

class DataRefreshActions extends Notifier<void> {
  Future<void>? _inFlight;
  Set<DataRefreshQuery> _pending = {};

  @override
  void build() {
    ref.watch(syncServiceProvider);
    _inFlight = null;
    _pending = {};
  }

  Future<void> refresh({Iterable<DataRefreshQuery> extra = const []}) {
    _pending.addAll([...ref.read(dataRefreshQueriesProvider), ...extra]);
    final running = _inFlight;
    if (running != null) return running;
    final service = ref.read(syncServiceProvider);
    final pending = _pending;
    final work = _execute(service, pending);
    _inFlight = work;
    return work.whenComplete(() {
      if (identical(_inFlight, work)) _inFlight = null;
    });
  }

  Future<void> _execute(SyncService service, Set<DataRefreshQuery> pending) async {
    try {
      if (service.currentStatus == SyncServiceStatus.offline) throw DataRefreshFailure.offline;
      if (!service.canSync) throw DataRefreshFailure.notReady;
      await service.syncNow();
      final completed = <DataRefreshQuery>{};
      while (pending.isNotEmpty) {
        // A late response must never requery the next account's database.
        if (!ref.mounted || !identical(service, ref.read(syncServiceProvider))) return;
        final query = pending.first;
        pending.remove(query);
        if (completed.add(query)) {
          final reloaded = ref.refresh(query);
          await reloaded;
        }
      }
    } on DataRefreshFailure {
      rethrow;
    } catch (_) {
      throw service.currentStatus == SyncServiceStatus.offline
          ? DataRefreshFailure.offline
          : DataRefreshFailure.failed;
    } finally {
      pending.clear();
    }
  }
}
