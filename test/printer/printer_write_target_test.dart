import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/printer/data/printer_write_target.dart';

WriteCandidate candidate(
  String service,
  String characteristic, {
  bool write = true,
  bool writeWithoutResponse = true,
}) => WriteCandidate(
  service: service,
  characteristic: characteristic,
  canWrite: write,
  canWriteWithoutResponse: writeWithoutResponse,
);

void main() {
  test('a known thermal pair wins over an unrelated writable characteristic', () {
    final target = selectWriteTarget([
      candidate('1234', '5678'),
      candidate('ff00', 'ff02'),
    ]);
    expect(target?.service, 'ff00');
    expect(target?.characteristic, 'ff02');
    expect(target?.withoutResponse, isFalse);
  });

  test('known service with an unknown characteristic is still accepted', () {
    final target = selectWriteTarget([candidate('fff0', 'fff5')]);
    expect(target?.characteristic, 'fff5');
  });

  test('write without response is used only when normal write is unavailable', () {
    final target = selectWriteTarget([
      candidate('ff00', 'ff02', write: false),
    ]);
    expect(target?.withoutResponse, isTrue);
  });

  test('falls back to any writable characteristic, or fails when none exists', () {
    final fallback = selectWriteTarget([candidate('abcd', 'ef01')]);
    expect(fallback?.characteristic, 'ef01');
    expect(
      selectWriteTarget([
        candidate('abcd', 'ef01', write: false, writeWithoutResponse: false),
      ]),
      isNull,
    );
  });

  test('splits ESC/POS bytes into MTU-safe chunks and keeps the content', () {
    final bytes = Uint8List.fromList(List.generate(181, (i) => i % 256));
    final chunks = chunksForBle(bytes);
    expect(chunks.map((chunk) => chunk.length), [180, 1]);
    expect([...chunks[0], ...chunks[1]], bytes);
    expect(chunksForBle(Uint8List(0)), isEmpty);
    expect(chunksForBle(Uint8List(180)), hasLength(1));
  });
}
