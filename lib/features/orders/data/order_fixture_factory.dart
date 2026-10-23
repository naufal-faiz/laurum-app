import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';

Order fixtureOrder(
  String id,
  String no,
  String cId,
  OrderStatus st,
  DateTime enter,
  DateTime est,
  int tot,
) => Order(
  id: id,
  ownerId: dummyOwnerId,
  createdAt: enter,
  orderNo: no,
  customerId: cId,
  status: st,
  source: OrderSource.kasir,
  discount: 0,
  enteredAt: enter,
  estimatedAt: est,
  subtotal: tot,
  total: tot,
);
