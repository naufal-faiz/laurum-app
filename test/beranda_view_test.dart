import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/beranda/state/beranda_view.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  final now = DateTime(2026, 11, 10, 9, 41);
  Customer person(String id, String name, DateTime created) => Customer(
    id: id,
    ownerId: 'own',
    createdAt: created,
    name: name,
  );
  Order order(String id, String customerId, OrderStatus status) => Order(
    id: id,
    ownerId: 'own',
    createdAt: now,
    updatedAt: now,
    orderNo: 'L-$id',
    customerId: customerId,
    status: status,
    source: OrderSource.kasir,
    discount: 0,
    enteredAt: now,
    estimatedAt: now,
    subtotal: 10000,
    total: 10000,
  );
  final customers = [
    CustomerDirectoryRow(person('c1', 'Bu Ratna', DateTime(2026, 11)), 14, 0, 0, 0, 0),
    CustomerDirectoryRow(person('c2', 'Pak Andi', DateTime(2026, 10)), 9, 0, 0, 0, 0),
    CustomerDirectoryRow(person('c3', 'Mbak Sari', DateTime(2026, 11, 5)), 0, 0, 0, 0, 0),
  ];

  test('BerandaView derives queue, customers and frequent rows', () {
    final view = BerandaView.from(
      businessName: 'Shanum Laundry',
      orders: [
        order('1', 'c1', OrderStatus.diproses),
        order('2', 'c2', OrderStatus.siap),
      ],
      customers: customers,
      revenue: 4850000,
      daily: const [1, 2, 3],
      now: now,
    );
    expect(view.businessName, 'Shanum Laundry');
    expect(view.total, 2);
    expect(view.updatedLabel, startsWith('Diperbarui '));
    expect(view.stages.map((stage) => stage.value), [0, 1, 1]);
    expect(view.savedCustomers, 3);
    expect(view.newCustomers, 2);
    expect(view.initials, ['M', 'B', 'P']);
    expect(view.revenue, 4850000);
    expect(view.daily, const [1, 2, 3]);
    expect(view.frequent.map((row) => row.name), ['Bu Ratna', 'Pak Andi']);
    expect(view.frequent.first.detail, '14 kali laundry');
    expect(view.frequent.first.trailing, '14×');
  });

  test('BerandaView handles an empty queue', () {
    final view = BerandaView.from(
      businessName: 'Laurum',
      orders: const [],
      customers: const [],
      revenue: 0,
      daily: const [],
      now: now,
    );
    expect(view.total, 0);
    expect(view.updatedLabel, 'Belum ada antrean');
    expect(view.stages.map((stage) => stage.value), [0, 0, 0]);
    expect(view.initials, isEmpty);
    expect(view.frequent, isEmpty);
  });
}
