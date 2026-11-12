import 'package:laurum/core/services/print_service.dart';

/// BLE advertisements often carry the name only in the scan response. Prefer
/// the platform name, then the advertised name, and drop nameless devices:
/// they are phones and beacons rather than printers.
PrinterDevice? printerFromScan({
  required String id,
  String platformName = '',
  String advName = '',
}) {
  final name = platformName.trim().isNotEmpty ? platformName.trim() : advName.trim();
  if (name.isEmpty) return null;
  return PrinterDevice(id: id, name: name);
}
