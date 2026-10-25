import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_deposit_controller.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('deposit adds a setoran and updates the ledger', (tester) async {
    final host = await pumpAntrean(tester, location: '/pelanggan/cust-001');
    await tester.scrollUntilVisible(find.text('Setor tabungan'), 300);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setor tabungan'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo sekarang'), findsOneWidget);
    expect(find.text('Saldo akhir menjadi Rp50.000'), findsOneWidget);
    await tester.tap(find.text('+Rp50.000'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo akhir menjadi Rp100.000'), findsOneWidget);
    await tester.ensureVisible(find.text('QRIS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan tabungan (Rp50.000)'));
    await tester.pumpAndSettle();
    final entries = await host.container
        .read(savingsRepositoryProvider)
        .getEntriesByCustomerId('cust-001');
    expect(entries, hasLength(4));
    expect(entries.first.amount, 50000);
    expect(entries.first.method, PayMethod.qris);
    expect(entries.first.note, 'Setoran tabungan');
    expect(entries.first.createdAt, DateTime(2026, 10, 16, 10, 45));
  });

  testWidgets('zero nominal is rejected with validation copy', (tester) async {
    final host = await pumpAntrean(tester, location: '/pelanggan/cust-001/setor');
    final notifier = host.container.read(customerDepositProvider('cust-001').notifier);
    expect(await notifier.save(), isFalse);
    await tester.pumpAndSettle();
    expect(find.text('Nominal harus lebih dari Rp0.'), findsOneWidget);
    final entries = await host.container
        .read(savingsRepositoryProvider)
        .getEntriesByCustomerId('cust-001');
    expect(entries, hasLength(3));
  });
}
