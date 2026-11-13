import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/persistence/drift_local_settings_repository.dart';

import 'local_account_devices.dart';

void main() {
  test('two devices restore and exchange contacts and queue through real Supabase RPCs', () async {
    final h = await LocalAccountDevices.open();
    addTearDown(h.close);
    final a = h.stores[0], b = h.stores[1];
    await a.start();
    final initial = await a.business.getProfile();
    await a.business.saveProfile(
      BusinessProfile(
        id: initial.id,
        ownerId: h.owner,
        createdAt: initial.createdAt,
        name: 'Laundry lintas perangkat',
      ),
    );
    final at = DateTime.now().toUtc();
    final customerId = const IdGenerator().newId();
    await a.customers.saveCustomer(
      Customer(id: customerId, ownerId: h.owner, createdAt: at, name: 'Pelanggan cloud'),
    );
    final orderId = const IdGenerator().newId();
    await a.orders.saveOrder(
      Order(
        id: orderId,
        ownerId: h.owner,
        createdAt: at,
        orderNo: 'A-0001',
        customerId: customerId,
        status: OrderStatus.diproses,
        source: OrderSource.kasir,
        discount: 0,
        enteredAt: at,
        estimatedAt: at,
        subtotal: 0,
        total: 0,
      ),
    );
    await a.sync.syncNow();
    await b.start(); // The application path must fetch, not just the pull runner.
    expect((await b.business.getProfile()).id, initial.id);
    expect((await b.customers.getCustomers()).single.id, customerId);
    expect((await b.orders.getActiveOrders()).single.id, orderId);
    final customer = (await b.customers.getCustomers()).single;
    await b.customers.saveCustomer(
      Customer(
        id: customer.id,
        ownerId: h.owner,
        createdAt: customer.createdAt,
        name: customer.name,
        notes: 'Diubah HP kedua',
      ),
    );
    final secondOrder = const IdGenerator().newId();
    await b.runner.run(() async {
      final orderNo = await OrderNumberGenerator(settings: DriftLocalSettingsRepository(b.db))
          .reserveOrderNo((await b.orders.getOrders()).map((order) => order.orderNo));
      expect(orderNo, 'A-0002');
      await b.orders.saveOrder(
        Order(
          id: secondOrder,
          ownerId: h.owner,
          createdAt: at,
          orderNo: orderNo,
          customerId: customerId,
          status: OrderStatus.diproses,
          source: OrderSource.kasir,
          discount: 0,
          enteredAt: at,
          estimatedAt: at,
          subtotal: 0,
          total: 0,
        ),
      );
    });
    await b.sync.syncNow();
    await a.sync.syncNow();
    expect((await a.customers.getCustomers()).single.notes, 'Diubah HP kedua');
    expect(
      (await a.orders.getActiveOrders()).map((order) => order.id),
      containsAll([orderId, secondOrder]),
    );
    await h.clients[1].from('businesses').insert({
      'id': const IdGenerator().newId(),
      'owner_id': h.owner,
      'created_at': initial.createdAt.toUtc().add(const Duration(seconds: 1)).toIso8601String(),
      'name': 'Legacy second-device profile',
    });
    await b.sync.syncNow();
    await a.sync.syncNow();
    expect((await b.business.getProfile()).id, initial.id);
    expect((await a.business.getProfile()).id, initial.id);
    expect(await b.db.select(b.db.businessRecords).get(), hasLength(2));
    expect(
      (await b.orders.getActiveOrders()).map((order) => order.id),
      containsAll([orderId, secondOrder]),
    );
    expect((a.sync.pendingChanges, b.sync.pendingChanges), (0, 0));
  }, skip: localSyncAvailable ? null : 'Start local Supabase and provide local test keys');
}
