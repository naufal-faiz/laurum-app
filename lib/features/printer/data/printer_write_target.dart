import 'dart:typed_data';

/// One writable GATT characteristic reported by a printer.
class WriteCandidate {
  const WriteCandidate({
    required this.service,
    required this.characteristic,
    required this.canWrite,
    required this.canWriteWithoutResponse,
  });
  final String service;
  final String characteristic;
  final bool canWrite;
  final bool canWriteWithoutResponse;

  bool get writable => canWrite || canWriteWithoutResponse;
}

class WriteTarget {
  const WriteTarget({
    required this.service,
    required this.characteristic,
    required this.withoutResponse,
  });
  final String service;
  final String characteristic;
  final bool withoutResponse;
}

/// Vendor defaults used by common 58 mm BLE printers. First match wins.
const preferredWritePairs = <(String, String)>[
  ('ff00', 'ff02'),
  ('18f0', '2af1'),
  ('fff0', 'fff2'),
  ('e7810a71-73ae-499d-8c15-faa9aef0c3f2', 'bef8d6c9-9c21-4c9e-b632-bd58c1009f9f'),
  ('49535343-fe7d-4ae5-8fa9-9fafd205e455', '49535343-8841-43f4-a8d4-ecbe34729bb3'),
];

const preferredWriteServices = <String>['ff00', '18f0', 'fff0', 'ff80', 'ae30'];

/// Picks the characteristic that carries ESC/POS bytes. Prefers known thermal
/// UUIDs, then any writable characteristic of a known service, then any
/// writable characteristic at all. A response is preferred when supported
/// because it flow-controls the printer buffer.
WriteTarget? selectWriteTarget(Iterable<WriteCandidate> candidates) {
  final list = candidates.toList();
  for (final pair in preferredWritePairs) {
    for (final c in list) {
      if (c.writable && c.service == pair.$1 && c.characteristic == pair.$2) {
        return _target(c);
      }
    }
  }
  for (final service in preferredWriteServices) {
    for (final c in list) {
      if (c.writable && c.service == service) return _target(c);
    }
  }
  for (final c in list) {
    if (c.canWriteWithoutResponse) return _target(c);
  }
  for (final c in list) {
    if (c.canWrite) return _target(c);
  }
  return null;
}

WriteTarget _target(WriteCandidate c) => WriteTarget(
  service: c.service,
  characteristic: c.characteristic,
  withoutResponse: !c.canWrite,
);

/// BLE writes are limited by the negotiated MTU, and iOS often settles near
/// 185 bytes. 180 keeps each chunk safe on both platforms.
const bleWriteChunk = 180;

List<Uint8List> chunksForBle(Uint8List bytes) {
  final chunks = <Uint8List>[];
  for (var start = 0; start < bytes.length; start += bleWriteChunk) {
    final end = start + bleWriteChunk < bytes.length ? start + bleWriteChunk : bytes.length;
    chunks.add(Uint8List.sublistView(bytes, start, end));
  }
  return chunks;
}
