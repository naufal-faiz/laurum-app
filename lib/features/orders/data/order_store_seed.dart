import 'package:laurum/features/orders/data/order_event_fixtures.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/order_store.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';

OrderStore initialOrderStore({required bool empty}) => empty
    ? OrderStore(orders: [], items: [], payments: [], events: [])
    : OrderStore(
        orders: orderFixtures,
        items: orderItemFixtures,
        payments: paymentFixtures,
        events: orderEventFixtures,
      );
