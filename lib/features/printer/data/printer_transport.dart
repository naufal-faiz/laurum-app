import 'dart:typed_data';

import 'package:laurum/core/services/print_service.dart';

/// The narrow seam a Bluetooth plugin implements. Keeping it separate lets
/// discovery, status and ESC/POS writing be tested without physical hardware.
abstract class PrinterTransport {
  Future<bool> isBluetoothOn();
  Future<List<PrinterDevice>> discover();
  Future<bool> connect(PrinterDevice device);
  Future<void> write(Uint8List bytes);
  Future<void> disconnect();
}
