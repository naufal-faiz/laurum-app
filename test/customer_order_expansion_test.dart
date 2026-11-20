import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/customers/state/customer_order_expansion.dart';
import 'package:laurum/features/customers/widgets/customer_orders_section.dart';
import 'package:laurum/features/orders/data/order_fixture_factory.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('show all expands beyond three and retains order navigation', (tester) async {
    final source = ProviderContainer(overrides: dummyRepositoryOverrides);
    final base = (await source.read(customerDetailProvider('cust-001').future))!;
    source.dispose();
    final extra = fixtureOrder(
      'ord-extra',
      'A-9999',
      'cust-001',
      OrderStatus.selesai,
      DateTime(2026, 10),
      DateTime(2026, 10, 2),
      25000,
    );
    final fourth = fixtureOrder(
      'ord-fourth',
      'A-9998',
      'cust-001',
      OrderStatus.selesai,
      DateTime(2026, 9, 30),
      DateTime(2026, 10),
      25000,
    );
    final history = ReportOrdersData(
      orders: [...base.history.orders, extra, fourth],
      customers: base.history.customers,
      items: base.history.items,
      payments: base.history.payments,
    );
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        customerDetailProvider('cust-001')
            .overrideWith((ref) async => CustomerDetailData(base.summary, history, base.movements)),
      ],
    );
    final host = await pumpAntrean(tester, location: '/pelanggan/cust-001', container: scope);
    final section = find.byType(CustomerOrdersSection);
    await tester.scrollUntilVisible(section, 500);
    expect(find.descendant(of: section, matching: find.byType(NotaCard)), findsNWidgets(3));
    final header = find.descendant(of: section, matching: find.byType(SectionHeader));
    final link = find.descendant(of: header, matching: find.text('Lihat semua'));
    await tester.ensureVisible(link);
    await tester.tap(link);
    await tester.pumpAndSettle();
    expect(scope.read(customerOrderExpansionProvider), contains('cust-001'));
    expect(tester.widget<CustomerOrdersSection>(section).showAll, isTrue);
    await tester.scrollUntilVisible(find.text('A-9998'), 500);
    expect(find.descendant(of: section, matching: find.byType(NotaCard)), findsNWidgets(4));
    expect(find.descendant(of: header, matching: find.text('Lihat semua')), findsNothing);
    await tester.ensureVisible(find.text('A-0142'));
    await tester.tap(find.text('A-0142'));
    await tester.pumpAndSettle();
    expect(find.text('Detail order'), findsOneWidget);
    host.router.pop();
    await tester.pumpAndSettle();
    host.router.go('/pelanggan/cust-002');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(CustomerOrdersSection), 500);
    expect(
      tester.widget<CustomerOrdersSection>(find.byType(CustomerOrdersSection)).showAll,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}
