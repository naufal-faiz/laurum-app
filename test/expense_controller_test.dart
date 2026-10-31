import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/services/photo_picker.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/expenses/state/expense_category_controller.dart';
import 'package:laurum/features/expenses/state/expense_delete_controller.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

void main() {
  late ProviderContainer scope;
  setUp(
    () => scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        photoPickerProvider.overrideWithValue(FakePhotoPicker(defaultPath: 'receipt.jpg')),
      ],
    ),
  );
  tearDown(() => scope.dispose());
  test('month fixture totals, save and soft delete update directory and reports', () async {
    final first = await scope.read(expenseDirectoryProvider.future);
    expect(first.total, 1850000);
    expect(first.expenses.length, 18);
    final range = ReportRange(DateTime(2026, 10, 12), DateTime(2026, 10, 19));
    final before = await scope.read(reportRepositoryProvider).getReport(range);
    final actions = scope.read(expenseFormProvider.notifier);
    expect(await actions.save(), isFalse);
    actions.category('cat-001');
    actions.nominal('0005000');
    actions.vendor(' Toko ');
    actions.note(' Sabun ');
    await actions.photo();
    expect(await actions.save(), isTrue);
    final after = await scope.read(expenseDirectoryProvider.future);
    expect(after.total, first.total + 5000);
    final saved = after.expenses.firstWhere((e) => e.note == 'Sabun');
    expect(saved.vendor, 'Toko');
    expect(saved.photoPath, 'receipt.jpg');
    expect(
      (await scope.read(reportRepositoryProvider).getReport(range)).expenses,
      before.expenses + 5000,
    );
    expect(await scope.read(expenseDeleteProvider(saved.id).notifier).delete(), isTrue);
    expect((await scope.read(expenseDirectoryProvider.future)).total, first.total);
    expect((await scope.read(reportRepositoryProvider).getReport(range)).expenses, before.expenses);
  });
  test('empty zero, first keypad replacement and backspace keep nominal rules', () {
    final actions = scope.read(expenseFormProvider.notifier);
    actions.key(AppNumpadKeyValue.zero);
    expect(scope.read(expenseFormProvider).text, '');
    actions.nominal('05000');
    expect(scope.read(expenseFormProvider).text, '5000');
    actions.key(AppNumpadKeyValue.two);
    actions.key(AppNumpadKeyValue.tripleZero);
    expect(scope.read(expenseFormProvider).amount, 2000);
    actions.nominal('5000');
    actions.key(AppNumpadKeyValue.backspace);
    expect(scope.read(expenseFormProvider).text, '');
    expect(scope.read(expenseFormProvider).valid, isFalse);
  });
  test('category requires unique name, persists and selects new category', () async {
    final actions = scope.read(expenseCategoryProvider.notifier);
    expect(await actions.save(), isFalse);
    actions.name(' bahan CUCI ');
    expect(await actions.save(), isFalse);
    actions.name('Perawatan mesin');
    expect(await actions.save(), isTrue);
    final all = await scope.read(expenseRepositoryProvider).getCategories();
    expect(all.last.name, 'Perawatan mesin');
    expect(scope.read(expenseFormProvider).categoryId, all.last.id);
    expect((await scope.read(expenseDirectoryProvider.future)).categories.last.id, all.last.id);
  });
}
