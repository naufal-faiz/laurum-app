import 'dart:async';

import 'package:drift/drift.dart';
import 'package:laurum/core/persistence/app_database.dart';

// UI subscriptions may pause; never expose Drift's internal update stream to them.
class DriftChangeMonitor {
  DriftChangeMonitor(this.db);
  final AppDatabase db;
  final _changes = StreamController<int>.broadcast();
  StreamSubscription<Set<TableUpdate>>? _subscription;
  int _revision = 0;
  Stream<int> get stream => _changes.stream;
  void start() {
    // Device preferences and sync bookkeeping do not change business query data.
    const metadata = {'local_settings', 'outbox', 'sync_cursors'};
    _subscription = db.tableUpdates().listen((updates) {
      if (updates.any((update) => !metadata.contains(update.table))) {
        _changes.add(++_revision);
      }
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    unawaited(_changes.close());
  }
}
