import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

Future<void> tapStatusSwitch(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(ToggleRow));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(AppSwitch));
  await tester.pumpAndSettle();
}

Future<String> createR4Order(
  WidgetTester tester,
  ProviderContainer scope, {
  bool savings = false,
}) async {
  await tester.tap(
    find.descendant(of: find.byType(BottomNavBar), matching: find.text('Transaksi')),
  );
  await tester.pumpAndSettle();
  scope.read(transactionDraftProvider.notifier)
    ..selectCustomer('cust-001')
    ..add(serviceFixtures.singleWhere((s) => s.id == 'srv-003'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Bayar'));
  await tester.pumpAndSettle();
  if (savings) {
    scope.read(checkoutControllerProvider.notifier).setSavings(value: true, due: 0);
    await tester.pumpAndSettle();
  } else {
    await tester.tap(find.text('Belum bayar'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('Simpan saja'));
  await tester.pumpAndSettle();
  final order = (await scope.read(orderRepositoryProvider).getOrderByOrderNo('A-0143'))!;
  await tester.ensureVisible(find.text('Lihat order'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Lihat order'));
  await tester.pumpAndSettle();
  return order.id;
}
