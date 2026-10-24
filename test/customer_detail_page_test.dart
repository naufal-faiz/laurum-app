import 'antrean_test_host.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/customers/pages/customer_edit_sheet.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('detail shows master totals, movements, notes and tabungan routes', (tester) async {
    final host = await pumpAntrean(tester, location: '/pelanggan/cust-001');
    expect(find.text('Pak Dedi Budiarto'), findsOneWidget);
    expect(find.text('0813-7788-1122'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('16 order'), 300);
    expect(find.text('16 order'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Setor tabungan'), 300);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setor tabungan'));
    await tester.pumpAndSettle();
    expect(find.text('Setor tabungan'), findsWidgets);
    host.router.pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Lihat riwayat mutasi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lihat riwayat mutasi'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat tabungan'), findsWidgets);
    host.router.pop();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(SavingsRow).first, 300);
    expect(find.text('+Rp50.000'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(NotaCard).first, 300);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(NotaCard).first, matching: find.text('A-0142')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Detail order'), findsOneWidget);
  });

  testWidgets('edit persists profile and cancel deactivation keeps it active', (tester) async {
    await pumpAntrean(tester, location: '/pelanggan/cust-001');
    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();
    final fields = find.descendant(
      of: find.byType(CustomerEditSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.first, 'Pak Dedi Baru');
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();
    expect(find.text('Pak Dedi Baru'), findsOneWidget);
    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nonaktifkan pelanggan'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(ConfirmModal), matching: find.text('Kembali')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ConfirmModal), findsNothing);
    expect(find.byType(CustomerEditSheet), findsOneWidget);
  });

  testWidgets('confirmed deactivation retains detail and disappears from directory', (
    tester,
  ) async {
    final host = await pumpAntrean(tester, location: '/pelanggan/cust-001');
    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nonaktifkan pelanggan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, nonaktifkan'));
    await tester.pumpAndSettle();
    expect(find.text('Pelanggan nonaktif. Riwayat tetap tersimpan.'), findsOneWidget);
    host.router.go('/pelanggan');
    await tester.pumpAndSettle();
    expect(find.text('Semua (47)'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Dedi');
    await tester.pumpAndSettle();
    expect(find.text('Tidak ditemukan'), findsOneWidget);
  });
}
