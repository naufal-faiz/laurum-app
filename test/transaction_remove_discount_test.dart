import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';

void main() {
  for (final maximum in [false, true]) {
    test('remove preserves valid discount and clamps excess maximum=$maximum', () {
      final scope = ProviderContainer();
      addTearDown(scope.dispose);
      final notifier = scope.read(transactionDraftProvider.notifier);
      final first = serviceFixtures[0];
      final second = serviceFixtures[1];
      notifier
        ..selectCustomer('cust-001')
        ..add(first)
        ..add(second)
        ..setNote('pewangi lavender');
      final initial = scope.read(transactionDraftProvider);
      final remaining = initial.lines.last.total;
      final discount = maximum ? initial.subtotal : remaining ~/ 2;
      notifier.setDiscount(discount);
      notifier.remove(first.id);
      final after = scope.read(transactionDraftProvider);
      expect(after.lines.single.service.id, second.id);
      expect(after.lines.single.qtyMilli, initial.lines.last.qtyMilli);
      expect(after.discount, maximum ? remaining : discount);
      expect(after.total, maximum ? 0 : remaining - discount);
      expect(after.customerId, initial.customerId);
      expect(after.note, initial.note);
      notifier.remove(second.id);
      final empty = scope.read(transactionDraftProvider);
      expect(empty.lines, isEmpty);
      expect((empty.subtotal, empty.discount, empty.total), (0, 0, 0));
      expect(empty.customerId, initial.customerId);
      expect(empty.note, initial.note);
    });
  }
}
