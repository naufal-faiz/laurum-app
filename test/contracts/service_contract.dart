import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';

import '../domain_samples.dart';
import 'repository_factory.dart';

void runServiceRepositoryContract(RepositoryFactory<ServiceRepository> factory) {
  late ServiceRepository repo;
  setUp(() async => repo = await factory());
  test('empty, upsert and immutable list', () async {
    expect(await repo.getServices(), isEmpty);
    expect(await repo.getServiceById('missing'), isNull);
    await repo.saveService(service('s'));
    await repo.saveService(service('s', days: 3));
    expect(await repo.getServices(), [service('s', days: 3)]);
    expect(await repo.getServiceById('s'), service('s', days: 3));
    expect((await repo.getServices()).clear, throwsUnsupportedError);
  });
  test('delete hides service from active and inactive lookup', () async {
    await repo.saveService(service('s'));
    await repo.deleteService('s');
    expect(await repo.getServiceById('s'), isNull);
    expect(await repo.getServices(includeInactive: true), isEmpty);
  });
}
