import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/photo_picker.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('date picker and fake photo are saved with expense', (tester) async {
    final picker = FakePhotoPicker(defaultPath: 'receipt.jpg');
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        photoPickerProvider.overrideWithValue(picker),
      ],
    );
    await pumpAntrean(tester, container: scope, location: '/lainnya/pengeluaran/baru');
    final calendar = find.text('Jumat, 16 Okt 2026');
    await tester.ensureVisible(calendar);
    await tester.tap(calendar);
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    final dialog = tester.element(find.byType(DatePickerDialog));
    await tester.tap(find.text(MaterialLocalizations.of(dialog).okButtonLabel));
    await tester.pumpAndSettle();
    expect(scope.read(expenseFormProvider).date.day, 15);
    final attach = find.text('Lampirkan');
    await tester.ensureVisible(attach);
    await tester.tap(attach);
    await tester.pumpAndSettle();
    expect(picker.pickPhotoCallCount, 1);
    expect(find.text('Foto dilampirkan'), findsOneWidget);
    final actions = scope.read(expenseFormProvider.notifier);
    actions.category('cat-001');
    actions.nominal('5000');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan pengeluaran'));
    await tester.pumpAndSettle();
    final expenses = await scope.read(expenseRepositoryProvider).getExpenses();
    final saved = expenses.firstWhere((e) => e.photoPath == 'receipt.jpg');
    expect(saved.spentAt.day, 15);
  });
}
