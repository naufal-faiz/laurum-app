import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';

import '../contracts/business_values.dart';
import '../domain_samples.dart';
import 'b1c_harness.dart';

void main() {
  late B1cHarness h;
  setUp(() => h = B1cHarness());
  tearDown(() => h.db.close());
  test('profile row and outbox roll back together', () async {
    await h.business.saveProfile(h.profile());
    final before = await h.business.getProfile();
    await h.failOutbox();
    await expectLater(h.business.saveProfile(h.profile(enabled: false)), throwsA(anything));
    expect(await h.business.getProfile(), before);
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(1));
  });
  test('receipt row and outbox roll back together', () async {
    await h.receipts.saveReceiptSettings(h.settings());
    final before = await h.receipts.getReceiptSettings();
    await h.failOutbox();
    await expectLater(h.receipts.saveReceiptSettings(h.settings(paper: 58)), throwsA(anything));
    expect(await h.receipts.getReceiptSettings(), before);
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(1));
  });
  test('service insert and soft delete are atomic with outbox', () async {
    await h.services.saveService(service('s'));
    await h.failOutbox();
    await expectLater(h.services.saveService(service('new')), throwsA(anything));
    await expectLater(h.services.deleteService('s'), throwsA(anything));
    expect(await h.services.getServiceById('new'), isNull);
    expect(serviceValue(await h.services.getServiceById('s')), serviceValue(service('s')));
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(1));
    await h.db.customStatement('DROP TRIGGER fail_outbox');
    await h.services.deleteService('s');
    final row = await h.db.select(h.db.serviceRecords).getSingle();
    expect(row.deletedAt, h.at);
    expect(row.isActive, isFalse);
    final outbox = await h.db.select(h.db.outboxRecords).get();
    final payload = jsonDecode(outbox.last.payload) as Map<String, dynamic>;
    expect(payload['deleted_at'], h.at.toIso8601String());
    expect(payload['is_active'], isFalse);
    expect(outbox.last.op, 'upsert');
  });
  test('local metadata and wire payload cover every B1c table', () async {
    await h.business.saveProfile(h.profile(enabled: false));
    await h.receipts.saveReceiptSettings(h.settings());
    await h.services.saveService(service('s'));
    final profile = await h.business.getProfile();
    final receipt = await h.receipts.getReceiptSettings();
    final item = (await h.services.getServiceById('s'))!;
    for (final record in [profile, receipt, item]) {
      expect(record.updatedAt, h.at);
      expect(record.syncState, RecordSyncState.pending);
    }
    final outbox = await h.db.select(h.db.outboxRecords).get();
    final payloads = {
      for (final o in outbox) o.targetTable: jsonDecode(o.payload) as Map<String, dynamic>,
    };
    expect(payloads['businesses']!['use_order_status'], isFalse);
    expect(payloads['receipt_settings']!['paper_mm'], 80);
    expect(payloads['services']!['kind'], 'kiloan');
    for (final p in payloads.values) {
      expect(p['owner_id'], 'owner');
      expect(p['updated_at'], h.at.toIso8601String());
      expect(p.containsKey('sync_state'), isFalse);
    }
  });
}
