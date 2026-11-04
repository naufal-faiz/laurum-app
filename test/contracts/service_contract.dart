import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';
import 'package:laurum/core/domain/service_item.dart';

import '../domain_samples.dart';
import 'business_values.dart';
import 'repository_factory.dart';

void runServiceRepositoryContract(RepositoryFactory<ServiceRepository> factory) {
  late ServiceRepository repo;
  setUp(() async => repo = await factory());
  test('empty, upsert and immutable list', () async {
    expect(await repo.getServices(), isEmpty);
    expect(await repo.getServiceById('missing'), isNull);
    await repo.saveService(service('s'));
    await repo.saveService(service('s', days: 3));
    expect((await repo.getServices()).map(serviceValue), [serviceValue(service('s', days: 3))]);
    expect(serviceValue(await repo.getServiceById('s')), serviceValue(service('s', days: 3)));
    expect((await repo.getServices()).clear, throwsUnsupportedError);
  });
  test('delete hides service from active and inactive lookup', () async {
    await repo.saveService(service('s'));
    await repo.deleteService('s');
    expect(await repo.getServiceById('s'), isNull);
    expect(await repo.getServices(includeInactive: true), isEmpty);
  });
  test('catalog sorts by sort_order with insertion ties and filters inactive', () async {
    ServiceItem entry(String id, int sort, {bool active = true}) => ServiceItem(
      id: id,
      ownerId: 'owner',
      createdAt: day,
      name: 'Layanan $id',
      kind: ServiceKind.satuan,
      price: 12345,
      durationDays: 0,
      sortOrder: sort,
      isActive: active,
    );
    await repo.saveService(entry('late', 9));
    await repo.saveService(entry('first', 1));
    await repo.saveService(entry('tie', 1));
    await repo.saveService(entry('off', 0, active: false));
    await repo.saveService(entry('first', 1));
    expect((await repo.getServices()).map((s) => s.id), ['first', 'tie', 'late']);
    expect((await repo.getServices(includeInactive: true)).map((s) => s.id), [
      'off',
      'first',
      'tie',
      'late',
    ]);
    expect(
      serviceValue(await repo.getServiceById('off')),
      serviceValue(entry('off', 0, active: false)),
    );
    await repo.deleteService('first');
    await repo.deleteService('first');
    await repo.deleteService('missing');
    expect((await repo.getServices()).map((s) => s.id), ['tie', 'late']);
  });
}
