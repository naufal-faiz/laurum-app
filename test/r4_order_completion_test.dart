import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_completion_controller.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';

import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  const id = 'ord-0142';
  final provider = orderCompletionProvider(id);

  test('successful print completes unpaid order with event and unchanged debt', () async {
    final printer = CompletionPrinter();
    final scope = await completionScope(printer);
    addTearDown(scope.dispose);
    final before = (await scope.read(orderDetailProvider(id).future))!;
    expect(await scope.read(provider.notifier).complete(), isTrue);
    final after = (await scope.read(orderDetailProvider(id).future))!;
    expect(after.order.status, OrderStatus.selesai);
    expect(after.outstanding, before.outstanding);
    expect(after.payments, before.payments);
    expect(after.events.length, before.events.length + 1);
    expect(after.events.last.toStatus, OrderStatus.selesai);
    expect(printer.calls, 1);
  });

  for (final throws in [false, true]) {
    test('print failure/exception ($throws) allows explicit completion without print', () async {
      final printer = CompletionPrinter(printSucceeds: false)..throwsOnPrint = throws;
      final scope = await completionScope(printer);
      addTearDown(scope.dispose);
      final controller = scope.read(provider.notifier);
      expect(await controller.complete(withoutPrint: true), isFalse);
      expect(await controller.complete(), isFalse);
      expect(scope.read(provider).busy, isFalse);
      expect(scope.read(provider).allowWithoutPrint, isTrue);
      expect(
        (await scope.read(orderRepositoryProvider).getOrderById(id))!.status,
        OrderStatus.diproses,
      );
      expect(await controller.complete(withoutPrint: true), isTrue);
      expect(printer.calls, 1);
    });
  }

  test('tracking mode blocks simplified completion before printing', () async {
    final printer = CompletionPrinter();
    final scope = await completionScope(printer, tracking: true);
    addTearDown(scope.dispose);
    expect(await scope.read(provider.notifier).complete(), isFalse);
    expect(printer.calls, 0);
  });

  test('double tap prints once and cancellation during print cannot be resurrected', () async {
    final printer = CompletionPrinter()..gate = Completer<bool>();
    final scope = await completionScope(printer);
    addTearDown(scope.dispose);
    final detail = (await scope.read(orderDetailProvider(id).future))!;
    final controller = scope.read(provider.notifier);
    final first = controller.complete();
    expect(await controller.complete(), isFalse);
    while (printer.calls == 0) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(await scope.read(orderActionsProvider.notifier).cancel(detail), isTrue);
    printer.gate!.complete(true);
    expect(await first, isFalse);
    expect(
      (await scope.read(orderRepositoryProvider).getOrderById(id))!.status,
      OrderStatus.dibatalkan,
    );
    expect(printer.calls, 1);
    expect(scope.read(provider).busy, isFalse);
  });
}
