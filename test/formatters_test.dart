import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/formatters/formatters.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  test('Rupiah keeps integer precision and negative prefix', () {
    expect(Formatters.rupiah(31500), 'Rp31.500');
    expect(Formatters.rupiah(-50000), '-Rp50.000');
    expect(Formatters.rupiah(0), 'Rp0');
    expect(Formatters.rupiah(9007199254740991), 'Rp9.007.199.254.740.991');
  });

  test('Gram formatting preserves all three decimal places', () {
    expect(Formatters.berat(3500), '3,5 kg');
    expect(Formatters.berat(1), '0,001 kg');
    expect(Formatters.berat(1010), '1,01 kg');
    expect(Formatters.berat(0), '0 kg');
    expect(Formatters.berat(-3500), '-3,5 kg');
    expect(Formatters.jumlah(1), '1 pcs');
  });

  test('Indonesian date and distinct UI/receipt times', () {
    final date = DateTime(2026, 10, 16, 10, 15);
    expect(Formatters.tanggal(date), 'Jumat, 16 Okt 2026');
    expect(Formatters.tanggal(date, ringkas: true), '16 Okt');
    expect(Formatters.jam(date), '10.15 WIB');
    expect(Formatters.jam(date, struk: true), '10:15');
  });

  test('Phone normalization preserves unsupported and empty input', () {
    expect(Formatters.telepon('081377881122'), '0813-7788-1122');
    expect(Formatters.telepon('+62 813 7788 1122'), '0813-7788-1122');
    expect(Formatters.telepon('0813-7788-1122'), '0813-7788-1122');
    expect(Formatters.telepon(''), '');
    expect(Formatters.telepon('123'), '123');
    expect(Formatters.nomorNota(143), 'A-0143');
  });
}
