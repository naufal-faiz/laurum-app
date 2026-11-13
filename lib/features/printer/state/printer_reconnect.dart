import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/saved_printer.dart';

enum PrinterReconnectResult { success, bluetoothOff, missing, failed }

typedef PrinterReconnectState = ({bool busy, PrinterReconnectResult? result});
final printerReconnectProvider =
    NotifierProvider.autoDispose<PrinterReconnect, PrinterReconnectState>(
      PrinterReconnect.new,
    );

class PrinterReconnect extends Notifier<PrinterReconnectState> {
  @override
  PrinterReconnectState build() => (busy: false, result: null);

  Future<void> reconnect() async {
    if (state.busy || ref.read(printerConnectionProvider).busy) return;
    state = (busy: true, result: null);
    var result = PrinterReconnectResult.failed;
    try {
      final service = ref.read(printServiceProvider);
      final device = service.connectedPrinter ?? await ref.read(savedPrinterProvider.future);
      if (!ref.mounted) return;
      if (device == null) {
        result = PrinterReconnectResult.missing;
      } else {
        final ok = await ref.read(printerConnectionProvider.notifier).connect(device);
        result = ok
            ? PrinterReconnectResult.success
            : service.status == PrintStatus.bluetoothOff
            ? PrinterReconnectResult.bluetoothOff
            : PrinterReconnectResult.failed;
      }
    } on Object {
      result = PrinterReconnectResult.failed;
    }
    if (ref.mounted) state = (busy: false, result: result);
  }
}
