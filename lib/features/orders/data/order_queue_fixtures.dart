import 'package:laurum/core/domain/order.dart';
import 'package:laurum/features/orders/data/order_queue_process_fixtures.dart';
import 'package:laurum/features/orders/data/order_queue_ready_fixtures.dart';

final orderQueueFixtures = <Order>[
  ...orderQueueReadyFixtures,
  ...orderQueueProcessFixtures,
];
