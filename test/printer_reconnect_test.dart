import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_reconnect.dart';

class DeferredReconnectPrinter extends FakePrintService {
  final pending = Completer<bool>();
  int connectCalls = 0;
  @override
  Future<bool> connect(PrinterDevice device) async {
    connectCalls++;
    if (!await pending.future) {
      status = PrintStatus.error;
      return false;
    }
    return super.connect(device);
  }
}

void main() {
  Future<ProviderContainer> scopeFor(FakePrintService printer, {bool saved = true}) async {
    final scope = ProviderContainer(overrides: [printServiceProvider.overrideWithValue(printer)]);
    addTearDown(scope.dispose);
    scope.listen(printerReconnectProvider, (_, _) {});
    if (saved) {
      final settings = scope.read(localSettingsRepositoryProvider);
      await settings.setString('printer_id', 'printer');
      await settings.setString('printer_name', 'Thermal 58');
    }
    return scope;
  }

  test('reconnect is visible, rejects duplicate taps and never prints', () async {
    final printer = DeferredReconnectPrinter();
    final scope = await scopeFor(printer);
    final controller = scope.read(printerReconnectProvider.notifier);
    final work = controller.reconnect();
    await Future<void>.delayed(Duration.zero);
    expect(scope.read(printerReconnectProvider).busy, isTrue);
    await controller.reconnect();
    expect(printer.connectCalls, 1);
    printer.pending.complete(true);
    await work;
    expect(scope.read(printerReconnectProvider).result, PrinterReconnectResult.success);
    expect(printer.printedReceipts, isEmpty);
  });

  test('connection failure reports a result without printing', () async {
    final printer = DeferredReconnectPrinter();
    final scope = await scopeFor(printer);
    final work = scope.read(printerReconnectProvider.notifier).reconnect();
    printer.pending.complete(false);
    await work;
    expect(scope.read(printerReconnectProvider).result, PrinterReconnectResult.failed);
    expect(printer.printedReceipts, isEmpty);
  });

  test('Bluetooth off and missing saved printer have distinct warning states', () async {
    final off = await scopeFor(FakePrintService(bluetoothOn: false));
    await off.read(printerReconnectProvider.notifier).reconnect();
    expect(off.read(printerReconnectProvider).result, PrinterReconnectResult.bluetoothOff);
    final missing = await scopeFor(FakePrintService(), saved: false);
    await missing.read(printerReconnectProvider.notifier).reconnect();
    expect(missing.read(printerReconnectProvider).result, PrinterReconnectResult.missing);
  });
}
