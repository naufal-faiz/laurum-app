import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/features/transactions/pages/contact_picker_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('import reviews a contact before saving and selecting it', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    final repository = host.container.read(customerRepositoryProvider);
    final before = await repository.getCustomers();
    final draft = host.container.read(transactionDraftProvider);
    await tester.tap(find.text('Impor kontak'));
    await tester.pumpAndSettle();
    expect(find.byType(ContactPickerSheet), findsOneWidget);
    await tester.tap(find.text('Agus Pratama'));
    await tester.pumpAndSettle();
    expect(find.byType(AddCustomerSheet), findsOneWidget);
    final fields = find.descendant(
      of: find.byType(AddCustomerSheet),
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(fields.first).controller!.text, 'Agus Pratama');
    expect((await repository.getCustomers()).length, before.length);
    expect(host.container.read(transactionDraftProvider), same(draft));
    await tester.tap(find.text('Simpan pelanggan'));
    await tester.pumpAndSettle();
    final customers = await repository.getCustomers();
    expect(customers.length, before.length + 1);
    expect(
      host.container.read(transactionDraftProvider).customerId,
      customers.singleWhere((c) => c.name == 'Agus Pratama').id,
    );
    expect(find.byType(AddCustomerSheet), findsNothing);
    expect(find.text('Agus Pratama'), findsOneWidget);
  });
  testWidgets('cancel import leaves customers and transaction unchanged', (tester) async {
    final host = await pumpAntrean(tester, location: '/transaksi/baru');
    final repository = host.container.read(customerRepositoryProvider);
    final before = await repository.getCustomers();
    final draft = host.container.read(transactionDraftProvider);
    await tester.tap(find.text('Impor kontak'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AddCustomerSheet), findsNothing);
    expect((await repository.getCustomers()).length, before.length);
    expect(host.container.read(transactionDraftProvider), same(draft));
  });
}
