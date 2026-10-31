import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'antrean_test_host.dart';
import 'keyboard_test_helper.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('picker hides FAB for keyboard and leaves last service above FAB', (tester) async {
    configureKeyboardTest(tester);
    final host = await pumpAntrean(tester, location: '/transaksi/baru/layanan');
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await expectKeyboardVisible(tester, field: find.byType(AppSearchField));
    expect(find.byType(FloatingActionButton), findsNothing);
    FocusManager.instance.primaryFocus?.unfocus();
    tester.view.viewInsets = const FakeViewPadding();
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final catalog = await host.container.read(serviceCatalogProvider.future);
    final last = catalog.where((s) => s.isActive && s.kind == ServiceKind.satuan).last;
    await tester.drag(find.byType(ListView).first, const Offset(0, -4000));
    await tester.pumpAndSettle();
    final row = find.ancestor(of: find.text(last.name).last, matching: find.byType(MenuRow));
    expect(row.hitTestable(), findsOneWidget);
    expect(
      tester.getRect(row).bottom,
      lessThanOrEqualTo(tester.getRect(find.byType(FloatingActionButton)).top),
    );
    expect(tester.takeException(), isNull);
  });
}
