import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/printer/state/printer_connection.dart';

/// Reconnects the printer saved by the last successful connect. The attempt is
/// silent: when the printer is off the page simply keeps its normal state.
/// Auto-disposed so opening the printer page retries the saved device.
final printerRestoreProvider = FutureProvider.autoDispose<void>((ref) async {
  final settings = ref.watch(localSettingsRepositoryProvider);
  final id = await settings.getString('printer_id');
  final name = await settings.getString('printer_name');
  if (id == null || id.isEmpty || name == null) return;
  final service = ref.watch(printServiceProvider);
  if (service.status != PrintStatus.connected) {
    try {
      await service.connect(PrinterDevice(id: id, name: name));
    } on Object {
      /* Silent: a missing printer must not block the page. */
    }
  }
  ref.invalidate(printerConnectionProvider);
});
