import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_change_monitor.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

void main() {
  test('printer and sync metadata do not invalidate business query subscribers', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final monitor = DriftChangeMonitor(db)..start();
    final revisions = <int>[];
    final subscription = monitor.stream.listen(revisions.add);
    addTearDown(() async {
      await subscription.cancel();
      await monitor.dispose();
      await db.close();
    });
    final settings = DriftLocalSettingsRepository(db);
    await settings.setString('printer_id', 'printer');
    await settings.setString('printer_name', 'Printer BLE');
    await settings.setString('last_synced_at', '2026-11-13');
    db.notifyUpdates({const TableUpdate('outbox'), const TableUpdate('sync_cursors')});
    await Future<void>.delayed(Duration.zero);
    expect(revisions, isEmpty);
    final customerChange = monitor.stream.first;
    db.notifyUpdates({const TableUpdate('customers'), const TableUpdate('outbox')});
    await customerChange;
    expect(revisions, [1]);
  });
}
