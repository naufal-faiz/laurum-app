import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('draft adds services, steps quantities and computes totals', () {
    final notifier = container.read(transactionDraftProvider.notifier);
    final setrika = serviceFixtures.firstWhere((s) => s.id == 'srv-003');
    final bed = serviceFixtures.firstWhere((s) => s.id == 'srv-004');
    notifier.selectCustomer('cust-001');
    notifier.add(setrika);
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 1000);
    notifier.add(setrika);
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 1500);
    notifier.setQuantity('srv-003', 3500);
    notifier.add(bed);
    var draft = container.read(transactionDraftProvider);
    expect(draft.subtotal, 56500);
    expect(draft.itemCount, 2);
    notifier.setDiscount(6500);
    notifier.setNote('pewangi lavender');
    draft = container.read(transactionDraftProvider);
    expect(draft.total, 50000);
    expect(draft.isEmpty, isFalse);
    notifier.remove('srv-004');
    expect(container.read(transactionDraftProvider).subtotal, 31500);
  });

  test('discount cannot exceed subtotal and draft can be cleared', () {
    final notifier = container.read(transactionDraftProvider.notifier);
    notifier.add(serviceFixtures.firstWhere((s) => s.id == 'srv-003'));
    expect(() => notifier.setDiscount(999999), throwsArgumentError);
    notifier.setQuantity('srv-003', 1);
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 500);
    notifier.clear();
    expect(container.read(transactionDraftProvider).isEmpty, isTrue);
  });
}
