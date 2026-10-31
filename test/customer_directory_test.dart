import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('directory searches, filters, shows empty result and opens routes', (tester) async {
    final host = await pumpAntrean(tester, location: '/pelanggan');
    expect(find.text('Semua (48)'), findsOneWidget);
    expect(find.text('Ada piutang (5)'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '081377881122');
    await tester.pumpAndSettle();
    expect(find.text('Pak Dedi Budiarto'), findsOneWidget);
    expect(find.text('16 order • Total: Rp580.000'), findsOneWidget);
    expect(find.text('Belum bayar Rp31.500'), findsOneWidget);
    expect(find.text('Tabungan Rp50.000'), findsOneWidget);
    await tester.tap(find.text('Ada piutang (5)'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Budi Santoso');
    await tester.pumpAndSettle();
    expect(find.text('Tidak ditemukan'), findsOneWidget);
    await tester.tap(find.descendant(of: find.byType(ChipBar), matching: find.text('Semua (48)')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(CustomerRow), matching: find.text('Budi Santoso')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Detail pelanggan'), findsWidgets);
    host.router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Impor kontak'));
    await tester.pumpAndSettle();
    expect(find.text('Impor kontak HP'), findsWidgets);
  });

  testWidgets('directory actions sit above the list without a footer', (tester) async {
    await pumpAntrean(tester, location: '/pelanggan');
    expect(find.byType(FooterBar), findsNothing);
    expect(find.widgetWithText(AppButton, 'Impor kontak'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Pelanggan baru'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Impor kontak')).variant,
      AppButtonVariant.actionOutline,
    );
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Pelanggan baru')).icon,
      AppIcons.add,
    );
    expect(
      tester.getSize(find.widgetWithText(AppButton, 'Impor kontak')),
      tester.getSize(find.widgetWithText(AppButton, 'Pelanggan baru')),
    );
  });

  testWidgets('directory actions fit 320 px with 2x text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/pelanggan', textScale: 2);
    expect(find.text('Impor kontak'), findsOneWidget);
    expect(find.text('Pelanggan baru'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quick add updates directory and clears a search hiding the new customer', (
    tester,
  ) async {
    await pumpAntrean(tester, location: '/pelanggan');
    await tester.enterText(find.byType(TextField), 'tidak ada');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pelanggan baru'));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(AddCustomerSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), 'Pelanggan Uji');
    await tester.enterText(fields.at(1), '081234567890');
    await tester.tap(find.text('Simpan pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Semua (49)'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Pelanggan Uji');
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(CustomerRow), matching: find.text('Pelanggan Uji')),
      findsOneWidget,
    );
    expect(find.text('0 order • Total: Rp0'), findsOneWidget);
  });
}
