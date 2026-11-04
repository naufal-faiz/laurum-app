import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/printer/data/drift_receipt_settings_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

import '../contracts/business_values.dart';
import '../domain_samples.dart';
import 'b1c_harness.dart';

void main() {
  test('all B1c repositories survive database close and reopen', () async {
    final dir = await Directory.systemTemp.createTemp('laurum-b1c-');
    final file = File('${dir.path}/account.db');
    var db = AppDatabase(NativeDatabase(file));
    addTearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });
    var writer = OutboxWriter(db, DriftTransactionRunner(db));
    final business = DriftBusinessRepository(db, 'owner', writer);
    final receipts = DriftReceiptSettingsRepository(db, 'owner', writer);
    final services = DriftServiceRepository(db, 'owner', writer);
    final h = B1cHarness();
    addTearDown(h.db.close);
    await business.saveProfile(h.profile(enabled: false));
    await receipts.saveReceiptSettings(h.settings());
    await services.saveService(service('s'));
    await db.close();
    db = AppDatabase(NativeDatabase(file));
    writer = OutboxWriter(db, DriftTransactionRunner(db));
    final reread = DriftBusinessRepository(db, 'owner', writer);
    expect(businessValue(await reread.getProfile()), businessValue(h.profile(enabled: false)));
    expect(receiptValue(await reread.getReceiptSettings()), receiptValue(h.settings()));
    expect(
      serviceValue(await DriftServiceRepository(db, 'owner', writer).getServiceById('s')),
      serviceValue(service('s')),
    );
    expect(await db.select(db.outboxRecords).get(), hasLength(3));
  });
}
