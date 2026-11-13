import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/persistence/account_storage.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_sync_remote_applier.dart';

import 'sync_wire_rows.dart';

void main() {
  test('reopening an affected account keeps profiles and contacts usable', () async {
    final folder = await Directory.systemTemp.createTemp('laurum-duplicate-reopen-');
    final storage = AccountStorage(directory: () async => folder);
    addTearDown(() async {
      await storage.close();
      await folder.delete(recursive: true);
    });
    final first = (await storage.activate(wireOwner))!;
    final applier = DriftSyncRemoteApplier(first.db, wireOwner);
    await applier.apply('businesses', [
      allWireRows().first,
      {
        ...allWireRows().first,
        'id': const IdGenerator().newId(),
        'created_at': '2026-11-07T00:00:00Z',
      },
    ]);
    await applier.apply('customers', [customerRow()]);
    await storage.close();
    final reopened = (await storage.activate(wireOwner))!;
    expect((await reopened.business.getProfile()).id, wireBusiness);
    expect((await reopened.customers.getCustomers()).single.id, wireCustomer);
  });
  test(
    'legacy profiles from two devices remain readable and editable without deleting data',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      final store = AccountStore(db, wireOwner, directory: () async => Directory.systemTemp);
      addTearDown(() async {
        await store.dispose();
        await db.close();
      });
      final applier = DriftSyncRemoteApplier(db, wireOwner);
      final rows = allWireRows();
      for (final (table, original) in [('businesses', rows[0]), ('receipt_settings', rows[4])]) {
        await applier.apply(table, [
          {...original, 'id': const IdGenerator().newId(), 'created_at': '2026-11-07T00:00:00Z'},
          original,
        ]);
      }
      final profile = await store.business.getProfile();
      expect(profile.id, wireBusiness);
      expect(profile.name, 'Laundry Sari');
      await store.business.saveProfile(profile);
      final settings = await store.business.getReceiptSettings();
      expect(settings.id, wireReceipt);
      await store.business.saveReceiptSettings(settings);
      expect(await db.select(db.businessRecords).get(), hasLength(2));
      expect(await db.select(db.receiptSettingRecords).get(), hasLength(2));
    },
  );
}
