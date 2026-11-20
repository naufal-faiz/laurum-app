import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/state/customer_directory_controller.dart';
import 'package:laurum/features/customers/state/customer_directory_expansion.dart';
import 'package:laurum/features/customers/widgets/customer_directory_footer_section.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('show all resets when search or filter changes', () {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    expect(scope.read(customerDirectoryExpansionProvider), isFalse);
    scope.read(customerDirectoryExpansionProvider.notifier).showAll();
    expect(scope.read(customerDirectoryExpansionProvider), isTrue);
    scope.read(customerDirectoryFilterProvider.notifier).select(1);
    expect(scope.read(customerDirectoryExpansionProvider), isFalse);
    scope.read(customerDirectoryExpansionProvider.notifier).showAll();
    scope.read(customerDirectorySearchProvider.notifier).set('Rina');
    expect(scope.read(customerDirectoryExpansionProvider), isFalse);
  });

  testWidgets('ten initial results expand to all customers without changing chip counts', (
    tester,
  ) async {
    final host = await pumpAntrean(tester, location: '/pelanggan');
    expect(find.text('Semua (48)'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Lihat semua'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    final footer = tester.widget<CustomerDirectoryFooterSection>(
      find.byType(CustomerDirectoryFooterSection),
    );
    expect(footer.shown, 10);
    expect(footer.total, 48);
    await tester.tap(find.text('Lihat semua'));
    await tester.pumpAndSettle();
    expect(host.container.read(customerDirectoryExpansionProvider), isTrue);
    await tester.scrollUntilVisible(
      find.text('Menampilkan 48 dari 48 pelanggan'),
      800,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    expect(find.text('Lihat semua'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search finds customers beyond the initial ten and hides unnecessary show all', (
    tester,
  ) async {
    await pumpAntrean(tester, location: '/pelanggan');
    final last = customerFixtures.last;
    await tester.enterText(find.byType(TextField), last.name);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(CustomerRow), matching: find.text(last.name)),
      findsOneWidget,
    );
    expect(find.text('Menampilkan 1 dari 1 pelanggan'), findsOneWidget);
    expect(find.text('Lihat semua'), findsNothing);
    expect(find.text('Semua (48)'), findsOneWidget);
  });
}
