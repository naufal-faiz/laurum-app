import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/domain/repositories/business_repository.dart';

import 'repository_factory.dart';

void runBusinessRepositoryContract(RepositoryFactory<BusinessRepository> factory) {
  late BusinessRepository repo;
  setUp(() async => repo = await factory());
  test('profile and receipt settings persist independently', () async {
    final profile = BusinessProfile(
      id: 'b',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Laundry',
      useOrderStatus: false,
    );
    final settings = ReceiptSettings(
      id: 'r',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      paperMm: 80,
      fontSize: 12,
      showAddress: false,
    );
    await repo.saveProfile(profile);
    await repo.saveReceiptSettings(settings);
    expect(await repo.getProfile(), profile);
    expect(await repo.getReceiptSettings(), settings);
    final changed = profile.withOrderStatus(enabled: true);
    await repo.saveProfile(changed);
    expect(await repo.getProfile(), changed);
    expect(await repo.getReceiptSettings(), settings);
  });
}
