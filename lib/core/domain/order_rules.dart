import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';

// DateTime represents WIB wall-clock time; UTC conversion belongs at the data boundary.
DateTime estimateReady(DateTime enteredAt, Iterable<ServiceItem> services) {
  if (enteredAt.isUtc) throw ArgumentError('Supply WIB local wall time');
  final items = services.toList();
  if (items.isEmpty || items.any((s) => s.durationDays < 0)) {
    throw ArgumentError('Invalid durations');
  }
  final days = items.fold(0, (longest, s) => s.durationDays > longest ? s.durationDays : longest);
  return DateTime(enteredAt.year, enteredAt.month, enteredAt.day + days, 17);
}

OrderStatus nextStatus(OrderStatus status, {bool cancel = false}) {
  if (status == OrderStatus.selesai || status == OrderStatus.dibatalkan) {
    throw StateError('Final order status cannot change');
  }
  if (cancel) return OrderStatus.dibatalkan;
  return switch (status) {
    OrderStatus.menungguJemput => OrderStatus.diproses,
    OrderStatus.diproses => OrderStatus.siap,
    OrderStatus.siap => OrderStatus.selesai,
    _ => throw StateError('Final order status cannot change'),
  };
}
