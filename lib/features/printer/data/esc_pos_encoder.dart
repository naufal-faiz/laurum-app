import 'dart:typed_data';

import 'package:laurum/core/services/print_service.dart';

/// Builds ESC/POS bytes from the same fixed-width lines the preview renders.
/// Pure Dart: no Bluetooth plugin and no printer are needed to verify it.
class EscPosEncoder {
  const EscPosEncoder();

  static const _init = <int>[0x1B, 0x40];
  static const _left = <int>[0x1B, 0x61, 0x00];
  static const _bigText = <int>[0x1D, 0x21, 0x01];
  static const _normalText = <int>[0x1D, 0x21, 0x00];
  static const _feed = <int>[0x0A, 0x0A, 0x0A, 0x0A];

  /// Normal text keeps the 32-column layout. The larger setting doubles the
  /// height only, because double width would break the fixed-width rows.
  Uint8List encode(ReceiptData data) {
    final out = BytesBuilder(copy: false)
      ..add(_init)
      ..add(_left);
    if (data.fontSize >= 13) out.add(_bigText);
    for (final line in data.lines) {
      out.add(_ascii(line));
      out.addByte(0x0A);
    }
    if (data.fontSize >= 13) out.add(_normalText);
    out.add(_feed);
    return out.toBytes();
  }

  /// The default ESC/POS code page is not Unicode. Anything outside printable
  /// ASCII becomes "?" instead of sending bytes that print as random glyphs.
  List<int> _ascii(String line) => [
    for (final rune in line.runes) rune >= 0x20 && rune <= 0x7E ? rune : 0x3F,
  ];
}
