import 'package:intl/intl.dart';

abstract final class Formatters {
  static final _integer = NumberFormat('#,##0', 'id_ID');

  static String rupiah(int rupiah) {
    final digits = _integer.format(rupiah).replaceFirst('-', '');
    return '${rupiah < 0 ? '-' : ''}Rp$digits';
  }

  static String berat(int gram) {
    final digits = gram.toString().replaceFirst('-', '').padLeft(4, '0');
    final fraction = digits.substring(digits.length - 3).replaceFirst(RegExp(r'0+$'), '');
    final whole = digits.substring(0, digits.length - 3);
    return '${gram < 0 ? '-' : ''}$whole${fraction.isEmpty ? '' : ',$fraction'} kg';
  }

  static String jumlah(int jumlah) => '$jumlah pcs';

  // Draft numpad text retains its decimal separator and trailing zeroes while editing.
  static String beratInput(String text) => '${text.isEmpty ? '0' : text} kg';

  // Dates are supplied as business-local wall time (WIB), not converted using the device zone.
  static String tanggal(DateTime tanggal, {bool ringkas = false}) =>
      DateFormat(ringkas ? 'd MMM' : 'EEEE, d MMM yyyy', 'id_ID').format(tanggal);

  static String jam(DateTime waktu, {bool struk = false}) => struk
      ? DateFormat('HH:mm', 'id_ID').format(waktu)
      : '${DateFormat('HH.mm', 'id_ID').format(waktu)} WIB';

  // Thermal receipt date: no weekday, year shown.
  static String tanggalStruk(DateTime tanggal) => DateFormat('d MMM yyyy', 'id_ID').format(tanggal);

  static String telepon(String telepon) {
    var digits = telepon.replaceAll(RegExp(r'[\s()-]'), '');
    if (digits.startsWith('+62')) digits = '0${digits.substring(3)}';
    if (digits.startsWith('62')) digits = '0${digits.substring(2)}';
    if (!RegExp(r'^08\d{8,11}$').hasMatch(digits)) return telepon;
    return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
  }

  static String nomorNota(int nomor) => 'A-${nomor.toString().padLeft(4, '0')}';
}
