import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('trash removes only its line, keeps edit and clamps discount', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    final services = serviceFixtures.where((s) => s.kind == ServiceKind.kiloan).take(2).toList();
    final notifier = host.container.read(transactionDraftProvider.notifier);
    notifier
      ..selectCustomer('cust-001')
      ..add(services[0])
      ..add(services[1])
      ..setNote('pewangi lavender');
    notifier.setDiscount(host.container.read(transactionDraftProvider).subtotal);
    await tester.pumpAndSettle();
    final remove = find.byTooltip('Hapus ${services[0].name}');
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pumpAndSettle();
    final after = host.container.read(transactionDraftProvider);
    expect(after.lines.single.service.id, services[1].id);
    expect((after.discount, after.total), (after.subtotal, 0));
    expect(after.customerId, 'cust-001');
    expect(after.note, 'pewangi lavender');
    await tester.ensureVisible(find.text('Ubah berat'));
    await tester.tap(find.text('Ubah berat'));
    await tester.pumpAndSettle();
    expect(find.text('Selesai'), findsOneWidget);
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    final last = find.byTooltip('Hapus ${services[1].name}');
    await tester.ensureVisible(last);
    await tester.tap(last);
    await tester.pumpAndSettle();
    final empty = host.container.read(transactionDraftProvider);
    expect((empty.lines.length, empty.discount, empty.total), (0, 0, 0));
    expect(find.text('Belum ada layanan'), findsOneWidget);
    expect(tester.widget<AppButton>(find.widgetWithText(AppButton, 'Bayar')).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}
