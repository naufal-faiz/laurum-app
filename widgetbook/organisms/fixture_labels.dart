import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';

String fixtureOrderSummary(String orderId) => orderItemFixtures
    .where((i) => i.orderId == orderId)
    .map(
      (i) =>
          '${i.serviceName} ${i.unit == 'kg' ? Formatters.berat(i.qtyMilli) : Formatters.jumlah(i.qtyMilli ~/ 1000)}',
    )
    .join(' • ');
