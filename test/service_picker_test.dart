import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/transactions/pages/service_picker_page.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('service picker lists active services, searches and adds', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.widgetWithText(AppButton, 'Pilih layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Sering dipakai'), findsOneWidget);
    expect(find.text('Kiloan'), findsWidgets);
    expect(find.text('Jas & gaun'), findsNothing);

    await tester.enterText(
      find.descendant(
        of: find.byType(ServicePickerPage),
        matching: find.byType(TextField),
      ),
      'bed',
    );
    await tester.pumpAndSettle();
    expect(find.text('Bed cover'), findsOneWidget);
    expect(find.text('Cuci setrika'), findsNothing);
    await tester.tap(find.text('Bed cover'));
    await tester.pumpAndSettle();

    final draft = host.container.read(transactionDraftProvider);
    expect(draft.itemCount, 1);
    expect(draft.lines.single.service.name, 'Bed cover');
    expect(find.text('1 pcs · Rp25.000'), findsOneWidget);
  });

  testWidgets('service search without results shows an empty state', (tester) async {
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.widgetWithText(AppButton, 'Pilih layanan'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(ServicePickerPage),
        matching: find.byType(TextField),
      ),
      'tidak ada',
    );
    await tester.pumpAndSettle();
    expect(find.text('Layanan tidak ditemukan'), findsOneWidget);
  });
}
