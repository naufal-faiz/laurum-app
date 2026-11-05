import 'dart:async';

import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/services/sync_service.dart';

// Local outbox monitor only. B2 owns network delivery and acknowledgements.
class DriftSyncService implements SyncService {
  DriftSyncService(this.db);
  final AppDatabase db;
  final _status = StreamController<SyncServiceStatus>.broadcast();
  StreamSubscription<int>? _subscription;
  int _pending = 0;
  Future<void> start() async {
    _pending = await _count();
    _subscription = db
        .customSelect(
          'SELECT COUNT(*) AS n FROM outbox',
          readsFrom: {db.outboxRecords},
        )
        .watchSingle()
        .map((r) => r.read<int>('n'))
        .listen((n) {
          _pending = n;
          _status.add(currentStatus);
        });
  }

  Future<int> _count() async =>
      (await db
              .customSelect(
                'SELECT COUNT(*) AS n FROM outbox',
              )
              .getSingle())
          .read<int>('n');
  Future<void> refresh() async {
    _pending = await _count();
    _status.add(currentStatus);
  }

  @override
  int get pendingChanges => _pending;
  @override
  DateTime? get lastSyncedAt => null;
  @override
  SyncServiceStatus get currentStatus =>
      _pending == 0 ? SyncServiceStatus.tersimpan : SyncServiceStatus.menyimpan;
  @override
  Stream<SyncServiceStatus> get statusStream => _status.stream;
  @override
  Future<void> syncNow() => refresh();
  @override
  void recordLocalChange() {} // Every persistent write already inserts its outbox row.
  @override
  void clearLocalState() {} // SQL transaction owns deletion; never reset a fake counter.
  Future<void> dispose() async {
    await _subscription?.cancel();
    // A paused offscreen listener must not block closing the account database.
    unawaited(_status.close());
  }
}
