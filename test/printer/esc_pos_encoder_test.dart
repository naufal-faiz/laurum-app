import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/features/printer/data/esc_pos_encoder.dart';

void main() {
  const encoder = EscPosEncoder();
  test('starts the printer, writes every line and feeds the paper', () {
    final bytes = encoder.encode(
      const ReceiptData(lines: ['LAURUM', 'TOTAL  10.000'], paperMm: 58, fontSize: 11),
    );
    expect(bytes.take(5), [0x1B, 0x40, 0x1B, 0x61, 0x00]);
    expect(String.fromCharCodes(bytes), contains('LAURUM\nTOTAL  10.000\n'));
    expect(bytes.skip(bytes.length - 4), everyElement(0x0A));
    expect(bytes, isNot(contains(0x1D)));
  });

  test('the large setting uses double height without breaking 32 columns', () {
    final bytes = encoder.encode(
      const ReceiptData(lines: ['TOTAL'], paperMm: 58, fontSize: 13),
    );
    expect(bytes, containsAllInOrder([0x1D, 0x21, 0x01]));
    expect(bytes, containsAllInOrder([0x1D, 0x21, 0x00]));
    expect(String.fromCharCodes(bytes), contains('TOTAL\n'));
  });

  test('non-ASCII characters become a safe placeholder, never raw UTF-8', () {
    final bytes = encoder.encode(
      const ReceiptData(lines: ['Rp 10.000 — selesai ✓'], paperMm: 58, fontSize: 11),
    );
    expect(String.fromCharCodes(bytes), contains('Rp 10.000 ? selesai ?'));
    expect(bytes, isNot(contains(greaterThan(0x7E))));
  });
}
