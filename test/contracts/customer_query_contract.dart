import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/repositories/customer_repository.dart';

import 'repository_factory.dart';

void runCustomerQueryContract(RepositoryFactory<CustomerRepository> factory) {
  test('phone aliases 0/62/8 are unique while original phone text is retained', () async {
    final repo = await factory();
    final a = Customer(
      id: 'a',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Élodie',
      phone: '+62 812-3456-7890',
    );
    await repo.saveCustomer(a);
    expect((await repo.getCustomerById('a'))!.phone, a.phone);
    for (final phone in ['081234567890', '81234567890']) {
      await expectLater(
        repo.saveCustomer(
          Customer(id: 'b', ownerId: 'owner', createdAt: a.createdAt, name: 'Lain', phone: phone),
        ),
        throwsStateError,
      );
    }
  });
  test('prefix query supports unicode, phones, literal wildcards and insertion order', () async {
    final repo = await factory();
    for (final (id, name, phone) in [
      ('z', 'Élodie', '+62 812-3456-7890'),
      ('a', 'ÉLISA', '081288888888'),
      ('b', '100% Bersih', ''),
      ('c', '_laundry', ''),
    ]) {
      await repo.saveCustomer(
        Customer(id: id, ownerId: 'owner', createdAt: DateTime(2026), name: name, phone: phone),
      );
    }
    expect((await repo.getCustomers(query: 'éli')).map((c) => c.id), ['a']);
    expect((await repo.getCustomers(query: 'É')).map((c) => c.id), ['z', 'a']);
    expect((await repo.getCustomers(query: '62812')).map((c) => c.id), ['z', 'a']);
    expect((await repo.getCustomers(query: '100%')).map((c) => c.id), ['b']);
    expect((await repo.getCustomers(query: '_')).map((c) => c.id), ['c']);
    expect(await repo.getCustomers(query: '%'), isEmpty);
    expect(await repo.getCustomers(query: 'nama0812'), isEmpty);
    expect((await repo.getCustomers()).map((c) => c.id), ['z', 'a', 'b', 'c']);
  });
}
