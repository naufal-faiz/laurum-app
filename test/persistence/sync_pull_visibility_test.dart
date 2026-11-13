import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_change_monitor.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';

import 'sync_wire_rows.dart';

void main() {
  test('committed remote rows notify mounted business queries', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final monitor = DriftChangeMonitor(db)..start();
    addTearDown(() async {
      await monitor.dispose();
      await db.close();
    });
    final changed = monitor.stream.first.timeout(const Duration(seconds: 2));
    await DriftSyncRemoteApplier(db, wireOwner).apply('customers', [customerRow()]);
    expect(await changed, greaterThan(0));
  });
}
