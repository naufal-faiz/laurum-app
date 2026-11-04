import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/receipt_settings_repository.dart';

import 'business_values.dart';
import 'repository_factory.dart';

void runReceiptSettingsRepositoryContract(RepositoryFactory<ReceiptSettingsRepository> factory) {
  late ReceiptSettingsRepository repo;
  setUp(() async => repo = await factory());
  test('receipt defaults and stable read identity', () async {
    final settings = await repo.getReceiptSettings();
    expect(settings.paperMm, 58);
    expect(settings.fontSize, 11);
    expect([
      settings.showAddress,
      settings.showCustomer,
      settings.showSavings,
      settings.showNote,
    ], everyElement(isTrue));
    expect(receiptValue(await repo.getReceiptSettings()), receiptValue(settings));
  });
  test('all receipt options round trip independently', () async {
    final initial = await repo.getReceiptSettings();
    final changed = ReceiptSettings(
      id: initial.id,
      ownerId: initial.ownerId,
      createdAt: initial.createdAt,
      paperMm: 80,
      fontSize: 14,
      showAddress: false,
      showCustomer: false,
      showSavings: false,
      showNote: false,
    );
    await repo.saveReceiptSettings(changed);
    expect(receiptValue(await repo.getReceiptSettings()), receiptValue(changed));
    await repo.saveReceiptSettings(initial);
    expect(receiptValue(await repo.getReceiptSettings()), receiptValue(initial));
  });
}
