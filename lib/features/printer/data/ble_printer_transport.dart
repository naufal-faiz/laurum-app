import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/data/ble_printer_scanner.dart';
import 'package:laurum/features/printer/data/printer_transport.dart';
import 'package:laurum/features/printer/data/printer_write_target.dart';

/// BLE printer link backed by flutter_blue_plus. Vendor quirks live in the
/// pure helpers; this class only moves data through the plugin.
class BlePrinterTransport implements PrinterTransport {
  BlePrinterTransport({BlePrinterScanner? scanner})
    : _scanner = scanner ?? const BlePrinterScanner();

  final BlePrinterScanner _scanner;
  static const _stateTimeout = Duration(seconds: 5);
  static const _connectTimeout = Duration(seconds: 15);
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _withoutResponse = false;

  @override
  Future<bool> isBluetoothOn() async {
    try {
      if (!await FlutterBluePlus.isSupported) return false;
      final state = await FlutterBluePlus.adapterState.first.timeout(_stateTimeout);
      return state == BluetoothAdapterState.on;
    } on Object {
      return false;
    }
  }

  @override
  Future<List<PrinterDevice>> discover() => _scanner.scan();

  @override
  Future<bool> connect(PrinterDevice device) async {
    try {
      await disconnect();
      final target = BluetoothDevice.fromId(device.id);
      _device = target;
      await target.connect(timeout: _connectTimeout);
      final services = await target.discoverServices();
      final selection = selectWriteTarget([
        for (final service in services)
          for (final characteristic in service.characteristics)
            WriteCandidate(
              service: service.uuid.str,
              characteristic: characteristic.uuid.str,
              canWrite: characteristic.properties.write,
              canWriteWithoutResponse: characteristic.properties.writeWithoutResponse,
            ),
      ]);
      _characteristic = selection == null ? null : _find(services, selection);
      _withoutResponse = selection?.withoutResponse ?? false;
      if (_characteristic == null) {
        await disconnect();
        return false;
      }
      return true;
    } on Object {
      await disconnect();
      return false;
    }
  }

  BluetoothCharacteristic? _find(List<BluetoothService> services, WriteTarget target) {
    for (final service in services.where((s) => s.uuid.str == target.service)) {
      for (final c in service.characteristics.where((c) => c.uuid.str == target.characteristic)) {
        return c;
      }
    }
    return null;
  }

  @override
  Future<void> write(Uint8List bytes) async {
    final characteristic = _characteristic;
    if (characteristic == null) throw StateError('Printer is not connected');
    for (final chunk in chunksForBle(bytes)) {
      await characteristic.write(chunk, withoutResponse: _withoutResponse, timeout: 10);
      if (_withoutResponse) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    }
  }

  @override
  Future<void> disconnect() async {
    final device = _device;
    _device = null;
    _characteristic = null;
    _withoutResponse = false;
    if (device == null) return;
    try {
      await device.disconnect();
    } on Object {
      /* The link was already gone. */
    }
  }
}
