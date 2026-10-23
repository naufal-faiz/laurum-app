import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/data/order_history_fixtures.dart';
import 'package:laurum/features/orders/data/order_queue_fixtures.dart';

final orderFixtures = <Order>[
  ...orderQueueFixtures,
  ...orderHistoryFixtures,
];
