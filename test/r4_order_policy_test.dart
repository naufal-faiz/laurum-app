import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';

void main() {
  test('default status policy retains every existing progression', () {
    expect(nextStatus(OrderStatus.menungguJemput), OrderStatus.diproses);
    expect(nextStatus(OrderStatus.diproses), OrderStatus.siap);
    expect(nextStatus(OrderStatus.siap), OrderStatus.selesai);
  });

  test('disabled status tracking permits processing to complete directly', () {
    expect(nextStatus(OrderStatus.diproses, useOrderStatus: false), OrderStatus.selesai);
    expect(nextStatus(OrderStatus.menungguJemput, useOrderStatus: false), OrderStatus.diproses);
    expect(nextStatus(OrderStatus.siap, useOrderStatus: false), OrderStatus.selesai);
  });

  test('final statuses remain immutable and cancellation retains priority', () {
    for (final enabled in [true, false]) {
      for (final status in [OrderStatus.selesai, OrderStatus.dibatalkan]) {
        expect(() => nextStatus(status, useOrderStatus: enabled), throwsStateError);
        expect(() => nextStatus(status, useOrderStatus: enabled, cancel: true), throwsStateError);
      }
      for (final status in [OrderStatus.menungguJemput, OrderStatus.diproses, OrderStatus.siap]) {
        expect(nextStatus(status, useOrderStatus: enabled, cancel: true), OrderStatus.dibatalkan);
      }
    }
  });

  test('initial status respects source only when status tracking is enabled', () {
    expect(initialOrderStatus(OrderSource.kasir), OrderStatus.diproses);
    expect(initialOrderStatus(OrderSource.whatsappAi), OrderStatus.menungguJemput);
    for (final source in OrderSource.values) {
      expect(initialOrderStatus(source, useOrderStatus: false), OrderStatus.diproses);
    }
  });

  test('processing label changes only in simplified mode', () {
    expect(orderStatusLabel(OrderStatus.diproses), 'Diproses');
    expect(orderStatusLabel(OrderStatus.diproses, useOrderStatus: false), 'Sedang dikerjakan');
    for (final status in [
      OrderStatus.menungguJemput,
      OrderStatus.siap,
      OrderStatus.selesai,
      OrderStatus.dibatalkan,
    ]) {
      expect(orderStatusLabel(status, useOrderStatus: false), orderStatusLabel(status));
    }
  });

  test('direct completion requires explicit mode and retains order values', () {
    final order = orderFixtures.firstWhere((o) => o.status == OrderStatus.diproses);
    expect(() => order.withStatus(OrderStatus.selesai), throwsStateError);
    final completed = order.withStatus(OrderStatus.selesai, useOrderStatus: false);
    expect(completed.status, OrderStatus.selesai);
    expect(completed.id, order.id);
    expect(completed.customerId, order.customerId);
    expect(completed.total, order.total);
    expect(completed.note, order.note);
    expect(order.status, OrderStatus.diproses);
    expect(
      () => completed.withStatus(OrderStatus.dibatalkan, useOrderStatus: false),
      throwsStateError,
    );
    final waiting = orderFixtures.firstWhere((o) => o.status == OrderStatus.menungguJemput);
    expect(() => waiting.withStatus(OrderStatus.selesai, useOrderStatus: false), throwsStateError);
  });
}
