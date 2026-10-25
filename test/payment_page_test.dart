import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  ProviderContainer seededDraft() {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    final draft = scope.read(transactionDraftProvider.notifier);
    draft.selectCustomer('cust-001');
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    draft.setQuantity('srv-003', 3500);
    draft.add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    draft.setNote('pewangi lavender, jangan dicampur pakaian putih');
    return scope;
  }

  testWidgets('payment applies savings, cash and shows change', (tester) async {
    final host = await pumpAntrean(
      tester,
      container: seededDraft(),
      location: '/transaksi/baru/bayar',
    );
    expect(find.text('Total tagihan'), findsOneWidget);
    expect(find.text('Rp56.500'), findsWidgets);
    expect(find.text('Saldo: Rp50.000'), findsOneWidget);
    await tester.tap(find.byType(AppSwitch));
    await tester.pumpAndSettle();
    expect(find.text('Tabungan dipakai -Rp50.000'), findsOneWidget);
    expect(find.text('Sisa bayar Rp6.500'), findsWidgets);

    await tester.ensureVisible(find.text('Uang diterima'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uang diterima'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppChip, 'Rp10.000'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan uang diterima'));
    await tester.pumpAndSettle();
    expect(host.container.read(checkoutControllerProvider).received, 10000);
    expect(find.text('Kembali Rp3.500'), findsOneWidget);

    await tester.tap(find.text('Simpan saja'));
    await tester.pumpAndSettle();
    expect(find.text('Nota tersimpan'), findsWidgets);
    expect(find.text('A-0143'), findsOneWidget);
    expect(find.textContaining('TOTAL'), findsOneWidget);
    expect(host.container.read(transactionDraftProvider).isEmpty, isTrue);
  });
}
