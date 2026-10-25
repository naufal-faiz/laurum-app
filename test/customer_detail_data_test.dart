import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/state/customer_edit_controller.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer scope;
  setUp(() => scope = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => scope.dispose());

  test('detail matches historical totals and chronological ledger balances', () async {
    final data = (await scope.read(customerDetailProvider('cust-001').future))!;
    expect(data.summary.orderCount, 16);
    expect(data.summary.historyTotal, 580000);
    expect(data.summary.debt, 31500);
    expect(data.summary.savings, 50000);
    expect(data.movements.map((row) => row.balance), [50000, 0, 25000]);
    expect(data.orders.map((o) => o.orderNo), ['A-0142', 'A-0115']);
    expect(await scope.read(customerDetailProvider('missing').future), isNull);
  });

  test('edit rejects invalid and duplicate input then preserves identity and ledger', () async {
    final customer = (await scope.read(customerRepositoryProvider).getCustomerById('cust-001'))!;
    final editor = scope.read(customerEditProvider.notifier)..start(customer);
    editor.setName('');
    expect(await editor.save(), isFalse);
    expect(scope.read(customerEditProvider).form.nameError, 'Nama wajib diisi.');
    editor.setName('Pak Dedi Baru');
    editor.setPhone('0812-8899-1234');
    expect(await editor.save(), isFalse);
    expect(scope.read(customerEditProvider).form.phoneError, contains('Bu Rina'));
    editor.setPhone('+62 813 7788 1122');
    expect(await editor.save(), isTrue);
    final saved = (await scope.read(customerRepositoryProvider).getCustomerById(customer.id))!;
    expect(saved.name, 'Pak Dedi Baru');
    expect(saved.phone, '081377881122');
    expect(saved.createdAt, customer.createdAt);
    expect(saved.ownerId, customer.ownerId);
    final data = (await scope.read(customerDetailProvider(customer.id).future))!;
    expect(data.summary.savings, 50000);
    expect(data.summary.debt, 31500);
  });

  test('deactivation hides from active list but retains detail and financial history', () async {
    final customer = (await scope.read(customerRepositoryProvider).getCustomerById('cust-001'))!;
    final editor = scope.read(customerEditProvider.notifier)..start(customer);
    expect(await editor.deactivate(), isTrue);
    final directory = await scope.read(customerDirectoryProvider.future);
    expect(directory, hasLength(47));
    expect(directory.where((row) => row.customer.id == customer.id), isEmpty);
    final data = (await scope.read(customerDetailProvider(customer.id).future))!;
    expect(data.summary.customer.isActive, isFalse);
    expect(data.summary.customer.deletedAt, isNull);
    expect(data.orders, hasLength(2));
    expect(data.summary.debt, 31500);
    expect(data.summary.savings, 50000);
  });
}
