import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  testWidgets('app test host preserves viewport, live keyboard and text scale', (tester) async {
    await initializeDateFormatting('id_ID');
    configureKeyboardTest(tester);
    await pumpAntrean(tester, location: '/transaksi/baru', textScale: 1.5);
    final context = tester.element(find.byType(FormScaffold));
    expect(MediaQuery.sizeOf(context), const Size(390, 844));
    expect(MediaQuery.textScalerOf(context).scale(10), 15);
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pumpAndSettle();
    expect(MediaQuery.viewInsetsOf(context).bottom, 300);
    expect(MediaQuery.sizeOf(context), const Size(390, 844));
  });
}
