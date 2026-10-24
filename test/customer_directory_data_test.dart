import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/customers/pages/customer_directory_data.dart';
import 'package:laurum/features/orders/pages/order_detail_controller.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  test('directory matches DATA MASTER and searches normalized phone with filters', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final rows = await scope.read(customerDirectoryProvider.future);
    expect(rows, hasLength(48));
    expect(filterCustomers(rows, filter: 1, search: ''), hasLength(5));
    expect(filterCustomers(rows, filter: 2, search: ''), hasLength(5));
    final dedi = filterCustomers(rows, filter: 0, search: '+62 813 7788 1122').single;
    expect(dedi.customer.name, 'Pak Dedi Budiarto');
    expect(dedi.orderCount, 16);
    expect(dedi.historyTotal, 580000);
    expect(dedi.debt, 31500);
    expect(dedi.savings, 50000);
    expect(filterCustomers(rows, filter: 1, search: '  bUdI SaNtOsO '), isEmpty);
    expect(filterCustomers(rows, filter: 0, search: '  bUdI SaNtOsO '), hasLength(1));
  });

  test('cancellation updates debt, counts and historical total without double counting', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    await scope.read(customerDirectoryProvider.future);
    final detail = (await scope.read(orderDetailProvider('ord-0142').future))!;
    expect(await scope.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    final rows = await scope.read(customerDirectoryProvider.future);
    final dedi = rows.singleWhere((row) => row.customer.id == 'cust-001');
    expect(dedi.debt, 0);
    expect(dedi.orderCount, 15);
    expect(dedi.historyTotal, 548500);
    expect(filterCustomers(rows, filter: 1, search: ''), hasLength(4));
  });
}
