import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';
import 'package:laurum/features/printer/state/saved_printer.dart';

/// Reconnects the printer saved by the last successful connect. The attempt is
/// silent: when the printer is off the page simply keeps its normal state.
/// Auto-disposed so opening the printer page retries the saved device.
final printerRestoreProvider = FutureProvider.autoDispose<void>((ref) async {
  final saved = await ref.read(savedPrinterProvider.future);
  if (!ref.mounted || saved == null) return;
  final service = ref.watch(printServiceProvider);
  if (service.status != PrintStatus.connected) {
    try {
      await ref.read(printerConnectionProvider.notifier).connect(saved, silent: true);
    } on Object {
      /* Silent: a missing printer must not block the page. */
    }
  }
});
