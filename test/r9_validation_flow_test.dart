import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('zero input disables both saves until COD is selected', (tester) async {
    final scope = r9Scope();
    scope.read(transactionDraftProvider.notifier)
      ..selectCustomer('cust-001')
      ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
    await pumpAntrean(tester, container: scope, location: '/transaksi/baru/bayar');
    await tester.ensureVisible(find.text('Uang diterima'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uang diterima'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Hapus digit').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan uang diterima'));
    await tester.pumpAndSettle();
    for (final label in ['Konfirmasi pembayaran', 'Kembali']) {
      expect(tester.widget<AppButton>(find.widgetWithText(AppButton, label)).onPressed, isNull);
    }
    expect(find.text('Isi jumlah atau pilih Bayar nanti (COD)'), findsOneWidget);
    await tester.ensureVisible(find.text('Bayar nanti (COD)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bayar nanti (COD)'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Kembali')).onPressed,
      isNotNull,
    );
  });
}
