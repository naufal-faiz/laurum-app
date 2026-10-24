import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/formatters/formatters.dart';

/// Fixed-width helpers for the 58 mm thermal receipt (32 columns).
abstract final class ReceiptLayout {
  static const columns = 32;
  static const rule = '--------------------------------';

  static String row(String left, String right) {
    final room = columns - right.length;
    final label = left.length > room ? left.substring(0, room) : left;
    return '$label${' ' * (columns - label.length - right.length)}$right';
  }

  static String center(String text) => '${' ' * ((columns - text.length) ~/ 2)}$text';

  static Iterable<String> centered(String text) => wrap(text, columns).map(center);

  static Iterable<String> centeredBalanced(String text) => balanced(text, columns).map(center);

  static Iterable<String> wrap(String text, int width) {
    final out = <String>[];
    var line = '';
    for (final word in text.split(RegExp(r'\s+'))) {
      final next = line.isEmpty ? word : '$line $word';
      if (next.length > width) {
        out.add(line);
        line = word;
      } else {
        line = next;
      }
    }
    if (line.isNotEmpty) out.add(line);
    return out;
  }

  // Balanced wrap keeps closing text centered in two even lines.
  static Iterable<String> balanced(String text, int width) {
    final words = text.split(RegExp(r'\s+'));
    final length = words.join(' ').length;
    final count = (length / width).ceil().clamp(1, words.length);
    final target = (length / count).ceil();
    final out = <String>[];
    var line = '';
    for (final word in words) {
      final next = line.isEmpty ? word : '$line $word';
      if (line.isNotEmpty && next.length > target && out.length < count - 1) {
        out.add(line);
        line = word;
      } else {
        line = next;
      }
    }
    if (line.isNotEmpty) out.add(line);
    return out;
  }

  static Iterable<String> note(String note) {
    final out = <String>[];
    var line = 'Catatan:';
    for (final word in note.split(RegExp(r'\s+'))) {
      final next = '$line $word';
      if (next.length > columns) {
        out.add(line);
        line = word;
      } else {
        line = next;
      }
    }
    out.add(line);
    return out;
  }

  static String quantity(OrderItem item) => item.unit == 'kg'
      ? Formatters.berat(item.qtyMilli)
      : Formatters.jumlah(item.qtyMilli ~/ 1000);
}
