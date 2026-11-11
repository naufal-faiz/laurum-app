import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/proposals/pages/proposal_weight_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('proposal weight blocks subminimum, normalizes zero and resets with service', (
    tester,
  ) async {
    await pumpAntrean(tester, location: '/antrean/usulan/prop-002');
    await tester.ensureVisible(find.text('Isi berat'));
    await tester.tap(find.text('Isi berat'));
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byType(ProposalWeightSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, '000');
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);
    await tester.enterText(field, '0,3');
    await tester.pumpAndSettle();
    expect(find.text('Berat minimal 0,5 kg.'), findsWidgets);
    expect(tester.widget<AppButton>(find.widgetWithText(AppButton, 'Simpan')).onPressed, isNull);
    Navigator.of(tester.element(find.byType(ProposalWeightSheet))).pop();
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Setujui jadi order')).onPressed,
      isNull,
    );
    await tester.ensureVisible(find.text('Isi berat'));
    await tester.tap(find.text('Isi berat'));
    await tester.pumpAndSettle();
    await tester.enterText(field, '0004.5');
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller!.text, '4,5');
    await tester.tap(find.widgetWithText(AppButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('4,5 kg'), findsOneWidget);
    expect(find.text('Rp40.500'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Setujui jadi order')).onPressed,
      isNotNull,
    );
    await tester.ensureVisible(find.text('Ubah'));
    await tester.tap(find.text('Ubah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuci kiloan'));
    await tester.pumpAndSettle();
    expect(find.text('Belum diketahui'), findsOneWidget);
    expect(find.text('Belum dihitung'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Setujui jadi order')).onPressed,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
  });
}
