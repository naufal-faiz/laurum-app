import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/organisms/receipt_toggle_list.dart';

import '../widgetbook/organisms/receipt_toggle_list_use_case.dart';
import 'organism_gallery.dart';

void main() {
  testWidgets('ReceiptToggleList edits four rows and locks two', (tester) async {
    var addressChanges = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReceiptToggleList(
              showAddress: true,
              showCustomer: true,
              showSavings: true,
              showNote: true,
              onAddressChanged: (_) => addressChanges++,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Nomor nota & tanggal'), findsOneWidget);
    expect(find.text('Rincian item & diskon'), findsOneWidget);
    expect(find.text('Selalu tampil'), findsNWidgets(2));
    expect(find.byType(AppSwitch), findsNWidgets(4));
    await tester.tap(find.byType(AppSwitch).first);
    expect(addressChanges, 1);
  });
  registerOrganismGallery('receipt_toggle_list', receiptToggleListUseCase.builder, height: 1000);
}
