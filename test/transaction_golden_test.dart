import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/customer_picker_sheet.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('transaction page golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    draft.setDiscount(5000);
    draft.setNote('pewangi lavender, jangan dicampur pakaian putih');
    await pumpAntrean(tester, container: scope, location: '/transaksi/baru');
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/transaction_page.png'),
    );
  });

  testWidgets('service picker golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/transaksi/baru/layanan');
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/service_picker.png'),
    );
  });

  testWidgets('add customer sheet golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/transaksi/baru');
    await tester.tap(find.text('Pilih pelanggan'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: find.byType(CustomerPickerSheet), matching: find.byType(TextField)),
      'tidak ada',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tambah pelanggan baru'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/add_customer_sheet.png'),
    );
  });

  testWidgets('payment page golden', (tester) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier);
    checkout.setSavings(value: true, due: 6500);
    checkout.setMode(PaymentMode.lunas, due: 6500);
    checkout.setReceived(10000, due: 6500);
    await pumpAntrean(tester, container: scope, location: '/transaksi/baru/bayar');
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/payment_page.png'),
    );
  });

  testWidgets('receipt page golden', (tester) async {
    tester.view.physicalSize = const Size(390, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    final checkout = scope.read(checkoutControllerProvider.notifier);
    checkout.setSavings(value: true, due: 6500);
    checkout.setMode(PaymentMode.lunas, due: 6500);
    checkout.setReceived(10000, due: 6500);
    final orderId = (await checkout.save())!;
    await pumpAntrean(tester, container: scope, location: '/transaksi/nota/$orderId');
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('antrean-golden')),
      matchesGoldenFile('goldens/receipt_page.png'),
    );
  });
}
