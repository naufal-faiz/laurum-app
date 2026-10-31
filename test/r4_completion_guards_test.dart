import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_completion_controller.dart';
import 'package:laurum/features/transactions/state/receipt_print_controller.dart';
import 'package:laurum/features/transactions/state/receipt_view.dart';

import 'r4_completion_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('old waiting and ready orders finish directly; final orders never reprint', () async {
    final printer = CompletionPrinter();
    final scope = await completionScope(printer);
    addTearDown(scope.dispose);
    final repo = scope.read(orderRepositoryProvider);
    for (final status in [OrderStatus.menungguJemput, OrderStatus.siap]) {
      final order = (await repo.getOrders(status: status)).first;
      final controller = scope.read(orderCompletionProvider(order.id).notifier);
      expect(await controller.complete(), isTrue);
      expect((await repo.getOrderById(order.id))!.status, OrderStatus.selesai);
      final events = await repo.getEventsByOrderId(order.id);
      expect(events.last.fromStatus, status);
      expect(events.last.toStatus, OrderStatus.selesai);
      expect(await controller.complete(), isFalse);
    }
    expect(printer.calls, 2);
  });

  test('switching tracking on during print leaves order active', () async {
    final printer = CompletionPrinter()..gate = Completer<bool>();
    final scope = await completionScope(printer);
    addTearDown(scope.dispose);
    const id = 'ord-0142';
    final controller = scope.read(orderCompletionProvider(id).notifier);
    final printing = controller.complete();
    while (printer.calls == 0) {
      await Future<void>.delayed(Duration.zero);
    }
    final business = scope.read(businessRepositoryProvider);
    await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: true));
    printer.gate!.complete(true);
    expect(await printing, isFalse);
    expect(
      (await scope.read(orderRepositoryProvider).getOrderById(id))!.status,
      OrderStatus.diproses,
    );
    expect(scope.read(orderCompletionProvider(id)).allowWithoutPrint, isFalse);
  });

  test('concurrent receipt requests use the printer once', () async {
    final printer = CompletionPrinter()..gate = Completer<bool>();
    final scope = await completionScope(printer);
    addTearDown(scope.dispose);
    const id = 'ord-0142';
    final controller = scope.read(orderCompletionProvider(id).notifier);
    final first = controller.complete();
    while (printer.calls == 0) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(scope.read(receiptPrintProvider).printing, isTrue);
    final receipt = (await scope.read(receiptViewProvider(id).future))!;
    expect(await scope.read(receiptPrintProvider.notifier).printReceipt(receipt), isFalse);
    printer.gate!.complete(true);
    expect(await first, isTrue);
    expect(await controller.complete(), isFalse);
    expect(printer.calls, 1);
  });
}
