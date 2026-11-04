import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/repositories/customer_repository.dart';

import 'customer_query_contract.dart';
import 'record_values.dart';
import 'repository_factory.dart';

Customer contractCustomer(String id, {String phone = '', bool active = true}) => Customer(
  id: id,
  ownerId: 'owner',
  createdAt: DateTime(2026, 10, 16),
  name: 'Pelanggan $id',
  phone: phone,
  isActive: active,
);

void runCustomerRepositoryContract(RepositoryFactory<CustomerRepository> factory) {
  runCustomerQueryContract(factory);
  late CustomerRepository repo;
  setUp(() async => repo = await factory());
  test('empty, insert, update and lookup', () async {
    expect(await repo.getCustomers(), isEmpty);
    expect(await repo.getCustomerById('missing'), isNull);
    await repo.saveCustomer(contractCustomer('a'));
    final changed = contractCustomer('a', phone: '081234567890');
    await repo.saveCustomer(changed);
    expect((await repo.getCustomers()).map(customerValue), [customerValue(changed)]);
    expect(customerValue(await repo.getCustomerById('a')), customerValue(changed));
    expect((await repo.getCustomers()).clear, throwsUnsupportedError);
  });
  test('active phone uniqueness ignores punctuation and allows same row update', () async {
    await repo.saveCustomer(contractCustomer('a', phone: '0812-3456-7890'));
    await expectLater(
      repo.saveCustomer(contractCustomer('b', phone: '081234567890')),
      throwsStateError,
    );
    await repo.saveCustomer(contractCustomer('a', phone: '081234567890'));
    expect(await repo.getCustomers(), hasLength(1));
  });
  test('inactive and soft deleted rows are filtered; phone can be reused', () async {
    await repo.saveCustomer(contractCustomer('a', phone: '0812', active: false));
    expect(await repo.getCustomers(), isEmpty);
    expect(await repo.getCustomers(includeInactive: true), hasLength(1));
    await repo.deleteCustomer('a');
    expect(await repo.getCustomerById('a'), isNull);
    expect(await repo.getCustomers(includeInactive: true), isEmpty);
    await repo.saveCustomer(contractCustomer('b', phone: '0812'));
    expect(await repo.getCustomers(), hasLength(1));
  });
}
