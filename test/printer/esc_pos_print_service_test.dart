import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/data/esc_pos_print_service.dart';
import 'package:laurum/features/printer/data/printer_transport.dart';

class FakeTransport implements PrinterTransport {
  bool bluetoothOn = true, connectSucceeds = true, writeFails = false;
  final devices = const [PrinterDevice(id: 'AA:BB', name: 'Thermal 58mm')];
  final writes = <Uint8List>[];
  int disconnects = 0;

  @override
  Future<bool> isBluetoothOn() async => bluetoothOn;

  @override
  Future<List<PrinterDevice>> discover() async => devices;

  @override
  Future<bool> connect(PrinterDevice device) async => connectSucceeds;

  @override
  Future<void> write(Uint8List bytes) async {
    if (writeFails) throw StateError('write failed');
    writes.add(bytes);
  }

  @override
  Future<void> disconnect() async => disconnects++;
}

void main() {
  const receipt = ReceiptData(lines: ['Struk'], paperMm: 58, fontSize: 11);
  late FakeTransport transport;
  late EscPosPrintService service;
  setUp(() {
    transport = FakeTransport();
    service = EscPosPrintService(transport);
  });

  test('bluetooth off blocks discovery until the user enables it', () async {
    transport.bluetoothOn = false;
    await expectLater(service.discover(), throwsStateError);
    expect(service.status, PrintStatus.bluetoothOff);
    transport.bluetoothOn = true;
    expect(await service.enableBluetooth(), isTrue);
    expect(service.status, PrintStatus.disconnected);
  });

  test('connects, writes ESC/POS bytes and keeps the printer identity', () async {
    final devices = await service.discover();
    expect(devices, hasLength(1));
    expect(await service.connect(devices.single), isTrue);
    expect(service.status, PrintStatus.connected);
    expect(service.connectedPrinter?.id, 'AA:BB');
    expect(await service.printReceipt(receipt), isTrue);
    expect(transport.writes.single, containsAllInOrder([0x1B, 0x40]));
    expect(String.fromCharCodes(transport.writes.single), contains('Struk'));
  });

  test('failed write reports an error and a failed connect clears identity', () async {
    await service.connect(transport.devices.single);
    transport.writeFails = true;
    expect(await service.printReceipt(receipt), isFalse);
    expect(service.status, PrintStatus.error);
    transport.connectSucceeds = false;
    expect(await service.connect(transport.devices.single), isFalse);
    expect(service.connectedPrinter, isNull);
    expect(service.status, PrintStatus.error);
  });

  test('printing while disconnected is rejected and disconnect closes transport', () async {
    expect(await service.printReceipt(receipt), isFalse);
    expect(transport.writes, isEmpty);
    await service.connect(transport.devices.single);
    service.disconnect();
    expect(service.status, PrintStatus.disconnected);
    expect(service.connectedPrinter, isNull);
    expect(transport.disconnects, 1);
  });
}
