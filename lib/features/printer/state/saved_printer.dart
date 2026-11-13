import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/repositories/local_settings_repository.dart';
import 'package:laurum/core/services/local_settings_providers.dart';
import 'package:laurum/core/services/print_service.dart';

/// Device preferences only; never part of the business sync payload.
final savedPrinterProvider = FutureProvider<PrinterDevice?>((ref) async {
  final settings = ref.watch(localSettingsRepositoryProvider);
  final id = await settings.getString('printer_id');
  final name = await settings.getString('printer_name');
  return id == null || id.isEmpty || name == null ? null : PrinterDevice(id: id, name: name);
});

Future<void> rememberPrinter(LocalSettingsRepository settings, PrinterDevice device) async {
  await settings.setString('printer_id', device.id);
  await settings.setString('printer_name', device.name);
}
