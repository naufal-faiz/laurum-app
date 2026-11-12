import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/data/ble_printer_discovery.dart';

/// BLE scan that keeps only named advertisements. A permission or radio error
/// is rethrown only when no printer was found, so a partial scan still works.
class BlePrinterScanner {
  const BlePrinterScanner({this.timeout = const Duration(seconds: 8)});
  final Duration timeout;

  Future<List<PrinterDevice>> scan() async {
    final found = <String, PrinterDevice>{};
    Object? failure;
    final subscription = FlutterBluePlus.onScanResults.listen((results) {
      for (final result in results) {
        final device = printerFromScan(
          id: result.device.remoteId.str,
          platformName: result.device.platformName,
          advName: result.device.advName,
        );
        if (device != null) found[device.id] = device;
      }
    });
    try {
      await FlutterBluePlus.startScan(timeout: timeout);
      await FlutterBluePlus.isScanning
          .where((scanning) => !scanning)
          .first
          .timeout(timeout + const Duration(seconds: 2));
    } on Object catch (error) {
      failure = error;
    } finally {
      await subscription.cancel();
      if (FlutterBluePlus.isScanningNow) {
        try {
          await FlutterBluePlus.stopScan();
        } on Object {
          /* The radio already stopped. */
        }
      }
    }
    if (found.isEmpty && failure != null) {
      throw Exception('Bluetooth scan failed: $failure');
    }
    return found.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
