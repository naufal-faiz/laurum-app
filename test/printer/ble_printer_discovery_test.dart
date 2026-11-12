import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/printer/data/ble_printer_discovery.dart';

void main() {
  test('uses the platform name first and trims it', () {
    final device = printerFromScan(
      id: 'AA:BB',
      platformName: ' Thermal 58mm ',
      advName: 'Other',
    );
    expect(device?.id, 'AA:BB');
    expect(device?.name, 'Thermal 58mm');
  });

  test('falls back to the advertised name', () {
    final device = printerFromScan(id: 'CC:DD', advName: 'Printer-58');
    expect(device?.name, 'Printer-58');
  });

  test('drops nameless advertisements such as phones and beacons', () {
    expect(printerFromScan(id: 'EE:FF'), isNull);
    expect(printerFromScan(id: 'EE:FF', platformName: ' '), isNull);
  });
}
