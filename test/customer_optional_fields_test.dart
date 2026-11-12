import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/customers/state/customer_edit_controller.dart';
import 'package:laurum/features/proposals/state/proposal_actions.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/transactions/state/add_customer_form.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer scope;
  setUp(() => scope = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => scope.dispose());

  test('new customer from AI proposal also accepts empty phone and address', () async {
    final draft = (await scope.read(proposalDraftProvider('prop-003').future))!
        .copyWith(phone: '', address: '');
    final review = (await scope.read(proposalReviewProvider('prop-003').future))!;
    expect(review.canApprove(draft), isTrue);
    final id = await scope.read(proposalActionsProvider('prop-003').notifier).approve(draft);
    expect(id, isNotNull);
    final order = (await scope.read(orderRepositoryProvider).getOrderById(id!))!;
    final customer = (await scope
        .read(customerRepositoryProvider)
        .getCustomerById(order.customerId))!;
    expect(customer.name, draft.name);
    expect([customer.phone, customer.address, customer.notes], ['', '', '']);
  });

  test('multiple customers can be created with only a name', () async {
    final form = scope.read(addCustomerFormProvider.notifier);
    expect(await form.save(), isNull);
    expect(scope.read(addCustomerFormProvider).nameError, isNotNull);
    for (final name in ['Pelanggan Satu', 'Pelanggan Dua']) {
      form.setName(name);
      final customer = (await form.save())!;
      final stored = (await scope.read(customerRepositoryProvider).getCustomerById(customer.id))!;
      expect(stored.name, name);
      expect([stored.phone, stored.address, stored.notes], ['', '', '']);
    }
  });

  test('edit clears optional fields for multiple customers and retains identity', () async {
    final repo = scope.read(customerRepositoryProvider);
    final editor = scope.read(customerEditProvider.notifier);
    for (final id in ['cust-001', 'cust-002']) {
      final original = (await repo.getCustomerById(id))!;
      editor.start(original);
      editor.setPhone('');
      editor.setAddress('');
      editor.setNotes('');
      expect(await editor.save(), isTrue);
      final stored = (await repo.getCustomerById(id))!;
      expect([stored.phone, stored.address, stored.notes], ['', '', '']);
      expect(stored.id, original.id);
      expect(stored.createdAt, original.createdAt);
    }
  });

  test('provided invalid phone is still rejected', () async {
    final form = scope.read(addCustomerFormProvider.notifier);
    form.setName('Pelanggan');
    form.setPhone('081');
    expect(await form.save(), isNull);
    final customer = (await scope.read(customerRepositoryProvider).getCustomerById('cust-001'))!;
    final editor = scope.read(customerEditProvider.notifier)..start(customer);
    editor.setPhone('081');
    expect(await editor.save(), isFalse);
  });
}
