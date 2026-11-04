import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/printer/data/drift_receipt_settings_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

import '../domain_samples.dart';
import 'b1c_harness.dart';

void main() {
  late B1cHarness h;
  setUp(() => h = B1cHarness());
  tearDown(() => h.db.close());
  test('empty reads have stable UUID defaults and never enqueue writes', () async {
    final profile = await h.business.getProfile();
    final receipt = await h.receipts.getReceiptSettings();
    final uuid = matches(
      RegExp(r'^[\da-f]{8}-[\da-f]{4}-4[\da-f]{3}-[89ab][\da-f]{3}-[\da-f]{12}$'),
    );
    expect(profile.id, uuid);
    expect(receipt.id, uuid);
    expect(profile.name, isEmpty);
    expect(profile.ownerId, 'owner');
    expect(profile.useOrderStatus, isTrue);
    expect((await h.business.getProfile()).id, profile.id);
    expect((await h.receipts.getReceiptSettings()).id, receipt.id);
    expect(await h.db.select(h.db.businessRecords).get(), isEmpty);
    expect(await h.db.select(h.db.receiptSettingRecords).get(), isEmpty);
    expect(await h.db.select(h.db.outboxRecords).get(), isEmpty);
  });
  test('singleton IDs cannot change after the first saved row', () async {
    await h.business.saveProfile(h.profile());
    await h.receipts.saveReceiptSettings(h.settings());
    await expectLater(h.business.saveProfile(h.profile(id: 'second')), throwsStateError);
    await expectLater(h.receipts.saveReceiptSettings(h.settings(id: 'second')), throwsStateError);
    expect(await h.db.select(h.db.businessRecords).get(), hasLength(1));
    expect(await h.db.select(h.db.receiptSettingRecords).get(), hasLength(1));
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(2));
  });
  test('owner guard prevents writes, ID theft, foreign reads and deletes', () async {
    await h.business.saveProfile(h.profile());
    await h.receipts.saveReceiptSettings(h.settings());
    await h.services.saveService(service('s'));
    final business = DriftBusinessRepository(h.db, 'other', h.writer);
    final receipts = DriftReceiptSettingsRepository(h.db, 'other', h.writer);
    final services = DriftServiceRepository(h.db, 'other', h.writer);
    await expectLater(business.saveProfile(h.profile()), throwsStateError);
    await expectLater(business.saveProfile(h.profile(owner: 'other')), throwsStateError);
    await expectLater(receipts.saveReceiptSettings(h.settings()), throwsStateError);
    await expectLater(receipts.saveReceiptSettings(h.settings(owner: 'other')), throwsStateError);
    await expectLater(services.saveService(service('s')), throwsStateError);
    await services.deleteService('s');
    expect(await services.getServices(includeInactive: true), isEmpty);
    expect(await services.getServiceById('s'), isNull);
    expect((await business.getProfile()).name, isEmpty);
    expect((await receipts.getReceiptSettings()).paperMm, 58);
    expect(await h.services.getServiceById('s'), isNotNull);
    expect(await h.db.select(h.db.outboxRecords).get(), hasLength(3));
  });
}
