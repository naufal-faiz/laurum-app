import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('Info Usaha: field dan Simpan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/lainnya/info-usaha');
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan'),
    );
  });

  testWidgets('Form Layanan: field nama/harga dan Simpan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/lainnya/layanan/baru');
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan layanan'),
    );
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).at(1),
      save: find.widgetWithText(AppButton, 'Simpan layanan'),
    );
  });

  testWidgets('Printer: teks struk dan Simpan pengaturan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/lainnya/printer');
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan pengaturan'),
    );
  });

  testWidgets('Setor tabungan: catatan dan Simpan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/pelanggan/cust-001/setor');
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.textContaining('Simpan tabungan').first,
    );
  });

  testWidgets('Pilih Layanan: pencarian di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/transaksi/baru/layanan');
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });

  testWidgets('Pencarian Pelanggan: pencarian di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/pelanggan');
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });

  testWidgets('Pencarian Layanan: pencarian di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/lainnya/layanan');
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });

  testWidgets('Pencarian Nota Laporan: pencarian di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/laporan');
    final vertical = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    );
    await tester.scrollUntilVisible(find.byType(AppSearchField), 400, scrollable: vertical);
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });

  testWidgets('Pilih Kontak: pencarian impor di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/pelanggan/impor');
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });

  testWidgets('Edit order: catatan nota dan Simpan perubahan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/order/ord-0127/edit');
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan perubahan'),
    );
  });

  testWidgets('Buat transaksi: catatan nota dan Bayar di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.widgetWithText(AppButton, 'Pilih layanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuci setrika').first);
    await tester.pumpAndSettle();
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Bayar'),
    );
  });

  testWidgets('Tambah pelanggan cepat: field dan Simpan pelanggan di atas keyboard', (
    tester,
  ) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/pelanggan');
    await tester.tap(find.widgetWithText(AppButton, 'Pelanggan baru'));
    await tester.pumpAndSettle();
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan pelanggan'),
    );
  });

  testWidgets('Edit pelanggan: field dan Simpan perubahan di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/pelanggan/cust-001');
    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();
    await expectKeyboardVisible(
      tester,
      field: find.byType(AppTextField).first,
      save: find.widgetWithText(AppButton, 'Simpan perubahan'),
    );
  });

  testWidgets('Pilih pelanggan: pencarian di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.text('Pilih pelanggan'));
    await tester.pumpAndSettle();
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField).first);
  });
}
