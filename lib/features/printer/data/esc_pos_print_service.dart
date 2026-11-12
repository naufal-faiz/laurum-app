import 'dart:async';

import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/data/esc_pos_encoder.dart';
import 'package:laurum/features/printer/data/printer_transport.dart';

/// Real [PrintService]: the transport talks Bluetooth, this class owns status
/// and turns the preview lines into ESC/POS bytes.
class EscPosPrintService implements PrintService {
  EscPosPrintService(this._transport, {this.encoder = const EscPosEncoder()});
  final PrinterTransport _transport;
  final EscPosEncoder encoder;
  PrintStatus _status = PrintStatus.disconnected;
  PrinterDevice? _connected;

  @override
  PrintStatus get status => _status;

  @override
  PrinterDevice? get connectedPrinter => _connected;

  @override
  Future<List<PrinterDevice>> discover() async {
    if (!await _transport.isBluetoothOn()) {
      _status = PrintStatus.bluetoothOff;
      throw StateError('Bluetooth is off');
    }
    final devices = await _transport.discover();
    if (_status != PrintStatus.connected) _status = PrintStatus.disconnected;
    return devices;
  }

  @override
  Future<bool> connect(PrinterDevice device) async {
    if (!await _transport.isBluetoothOn()) {
      _status = PrintStatus.bluetoothOff;
      return false;
    }
    _status = PrintStatus.connecting;
    final ok = await _transport.connect(device);
    if (!ok) {
      _connected = null;
      _status = PrintStatus.error;
      return false;
    }
    _connected = device;
    _status = PrintStatus.connected;
    return true;
  }

  @override
  Future<bool> printReceipt(ReceiptData data) async {
    if (_status != PrintStatus.connected || _connected == null) {
      _status = PrintStatus.disconnected;
      return false;
    }
    _status = PrintStatus.printing;
    try {
      await _transport.write(encoder.encode(data));
      _status = PrintStatus.connected;
      return true;
    } on Object {
      _status = PrintStatus.error;
      return false;
    }
  }

  /// Android/iOS do not let an app switch Bluetooth on silently; this rechecks
  /// after the user enables it in system settings.
  @override
  Future<bool> enableBluetooth() async {
    final on = await _transport.isBluetoothOn();
    if (on && _status == PrintStatus.bluetoothOff) {
      _status = PrintStatus.disconnected;
    }
    return on;
  }

  @override
  void disconnect() {
    unawaited(_transport.disconnect());
    _connected = null;
    _status = PrintStatus.disconnected;
  }
}
