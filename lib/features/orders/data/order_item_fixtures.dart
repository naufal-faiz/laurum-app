import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

OrderItem _it(
  String id,
  String oId,
  String sId,
  String sName,
  String unit,
  int qtyMilli,
  int price,
  int total,
) => OrderItem(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: DateTime(2026, 10),
  orderId: oId,
  serviceId: sId,
  serviceName: sName,
  unit: unit,
  qtyMilli: qtyMilli,
  unitPrice: price,
  lineTotal: total,
);

final orderItemFixtures = <OrderItem>[
  _it('item-127', 'ord-0127', 'srv-004', 'Bed cover', 'pcs', 2000, 25000, 50000),
  _it('item-128', 'ord-0128', 'srv-004', 'Bed cover', 'pcs', 10000, 25000, 250000),
  _it('item-129', 'ord-0129', 'srv-001', 'Cuci kering lipat', 'kg', 6000, 6000, 36000),
  _it('item-130', 'ord-0130', 'srv-003', 'Cuci setrika', 'kg', 3000, 9000, 27000),
  _it('item-131', 'ord-0131', 'srv-002', 'Cuci kiloan', 'kg', 3000, 7000, 21000),
  _it('item-132', 'ord-0132', 'srv-003', 'Cuci setrika', 'kg', 4000, 9000, 36000),
  _it('item-133', 'ord-0133', 'srv-001', 'Cuci kering lipat', 'kg', 5000, 6000, 30000),
  _it('item-134', 'ord-0134', 'srv-005', 'Selimut tebal', 'pcs', 1000, 20000, 20000),
  _it('item-135', 'ord-0135', 'srv-003', 'Cuci setrika', 'kg', 5000, 9000, 45000),
  _it('item-136', 'ord-0136', 'srv-003', 'Cuci setrika', 'kg', 18000, 9000, 162000),
  _it('item-137', 'ord-0137', 'srv-002', 'Cuci kiloan', 'kg', 4000, 7000, 28000),
  _it('item-138', 'ord-0138', 'srv-001', 'Cuci kering lipat', 'kg', 7000, 6000, 42000),
  _it('item-139', 'ord-0139', 'srv-004', 'Bed cover', 'pcs', 1000, 25000, 25000),
  _it('item-140', 'ord-0140', 'srv-004', 'Bed cover', 'pcs', 1000, 25000, 25000),
  _it('item-141', 'ord-0141', 'srv-003', 'Cuci setrika', 'kg', 3500, 9000, 31500),
  _it('item-142', 'ord-0142', 'srv-002', 'Cuci kiloan', 'kg', 4500, 7000, 31500),
];
