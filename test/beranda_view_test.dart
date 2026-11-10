import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
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

  OrderItem item(String id, String orderId, String service, {bool deleted = false}) => OrderItem(
    id: id,
    ownerId: 'own',
    createdAt: now,
    orderId: orderId,
    serviceId: service,
    serviceName: service,
    unit: 'kg',
    qtyMilli: 1000,
    unitPrice: 10000,
    lineTotal: 10000,
    deletedAt: deleted ? now : null,
  );

  test('top services count unique active orders, exclude deleted and cap at three', () {
    final view = BerandaView.from(
      businessName: 'Laurum',
      orders: [order('1', 'c1', OrderStatus.diproses), order('2', 'c2', OrderStatus.siap)],
      items: {
        '1': [
          item('a', '1', 'Cuci'),
          item('b', '1', 'Cuci'),
          item('c', '1', 'Setrika'),
          item('d', '1', 'Lipat'),
          item('e', '1', 'Sepatu'),
          item('f', '1', 'Hapus', deleted: true),
        ],
        '2': [item('g', '2', 'Cuci')],
        'selesai': [item('h', 'selesai', 'Tidak aktif')],
      },
      customers: const [],
      revenue: 0,
      daily: const [],
      now: now,
    );
    expect(view.stages.map((s) => s.label), ['Cuci', 'Lipat', 'Sepatu']);
    expect(view.stages.map((s) => s.value), [2, 1, 1]);
  });

  test('one order with one service produces one tile', () {
    final view = BerandaView.from(
      businessName: 'Laurum',
      orders: [order('1', 'c1', OrderStatus.diproses)],
      items: {
        '1': [item('a', '1', 'Cuci Setrika')],
      },
      customers: const [],
      revenue: 0,
      daily: const [],
      now: now,
    );
    expect(view.stages.single.label, 'Cuci Setrika');
    expect(view.stages.single.value, 1);
  });

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
    expect(view.stages, isEmpty); // No items supplied; never invent service counts.
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
    expect(view.stages, isEmpty);
    expect(view.initials, isEmpty);
    expect(view.frequent, isEmpty);
  });
}
