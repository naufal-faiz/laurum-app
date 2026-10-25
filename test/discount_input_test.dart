import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/discount_sheet.dart';
import 'package:laurum/features/transactions/state/discount_input.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'keyboard_test_helper.dart';

void main() {
  test('start kosong untuk nol dan berisi untuk nilai bukan nol', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final input = container.read(discountInputProvider.notifier);

    input.start(0);
    expect(container.read(discountInputProvider).text, '');
    input.start(5000);
    expect(container.read(discountInputProvider).text, '5000');
  });

  test('set hanya digit tanpa nol depan dan nol tunggal menjadi kosong', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final input = container.read(discountInputProvider.notifier);

    input.set('05000');
    expect(container.read(discountInputProvider).text, '5000');
    input.set('0');
    expect(container.read(discountInputProvider).text, '');
    input.set('12a3');
    expect(container.read(discountInputProvider).text, '123');
    input.set('');
    expect(container.read(discountInputProvider).text, '');
  });

  testWidgets('sheet diskon: kosong berarti nol dan field/tombol di atas keyboard', (tester) async {
    configureKeyboardTest(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await seedDraft(container);
    await pumpDiscountHost(tester, container);
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    expect(find.byType(DiscountSheet), findsOneWidget);
    final field = find.descendant(
      of: find.byType(DiscountSheet),
      matching: find.byType(TextField),
    );
    expect(tester.widget<AppTextField>(find.byType(AppTextField)).value, '');
    expect(find.text('0'), findsOneWidget);

    await expectKeyboardVisible(
      tester,
      field: field,
      save: find.widgetWithText(AppButton, 'Simpan diskon'),
    );
    await tester.tap(find.text('Simpan diskon'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).discount, 0);
  });

  testWidgets('sheet diskon: nilai awal bukan nol diseleksi semua', (tester) async {
    configureKeyboardTest(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await seedDraft(container);
    container.read(transactionDraftProvider.notifier).setDiscount(1000);
    await pumpDiscountHost(tester, container);
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byType(DiscountSheet),
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(field);
    await tester.showKeyboard(field);
    await tester.pumpAndSettle();
    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    expect(editable.controller.selection.baseOffset, 0);
    expect(editable.controller.selection.extentOffset, 4);
    await tester.enterText(field, '5000');
    await tester.tap(find.text('Simpan diskon'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).discount, 5000);
  });
}

Future<void> seedDraft(ProviderContainer container) async {
  container.read(transactionDraftProvider.notifier).add(serviceFixtures.first);
}

Future<void> pumpDiscountHost(WidgetTester tester, ProviderContainer container) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: Center(
              child: AppButton(
                'Buka',
                onPressed: () => DiscountSheet.show(context, ref),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
