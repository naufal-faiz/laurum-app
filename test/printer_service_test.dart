import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/print_service.dart';

void main() {
  const receipt = ReceiptData(lines: ['Struk'], paperMm: 58, fontSize: 11);

  test('fake printer discovers, connects and prints receipts', () async {
    final service = FakePrintService();
    expect(service.status, PrintStatus.disconnected);
    final devices = await service.discover();
    expect(devices, hasLength(2));
    expect(await service.connect(devices.first), isTrue);
    expect(service.status, PrintStatus.connected);
    expect(await service.printReceipt(receipt), isTrue);
    expect(service.printedReceipts.single.text, 'Struk');
    expect(service.status, PrintStatus.connected);
  });

  test('print failure leaves an error status and records the attempt', () async {
    final service = FakePrintService(printSucceeds: false);
    final devices = await service.discover();
    await service.connect(devices.last);
    expect(await service.printReceipt(receipt), isFalse);
    expect(service.status, PrintStatus.error);
    expect(service.printedReceipts, hasLength(1));
  });

  test('bluetooth off blocks discovery until enabled', () async {
    final service = FakePrintService(bluetoothOn: false);
    await expectLater(service.discover(), throwsStateError);
    expect(service.status, PrintStatus.bluetoothOff);
    expect(await service.enableBluetooth(), isTrue);
    expect(service.status, PrintStatus.disconnected);
    expect(await service.discover(), hasLength(2));
  });

  test('printing while disconnected is rejected', () async {
    final service = FakePrintService();
    expect(await service.printReceipt(receipt), isFalse);
    expect(service.printedReceipts, isEmpty);
  });
}
