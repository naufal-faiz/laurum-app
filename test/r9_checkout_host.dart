import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/main_dummy.dart';

import 'fake_id_generator.dart';

ProviderContainer r9Scope() => ProviderContainer(
  overrides: [
    ...dummyRepositoryOverrides,
    idGeneratorProvider.overrideWithValue(FakeIdGenerator(newValues: ['ord-0143'])),
  ],
);
Future<OrderDetailData> r9Checkout(
  ProviderContainer scope, {
  bool useStatus = false,
  PayTerm term = PayTerm.cod,
  int? received,
  bool saveExcess = false,
}) async {
  final business = scope.read(businessRepositoryProvider);
  await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: useStatus));
  scope.read(transactionDraftProvider.notifier)
    ..selectCustomer('cust-001')
    ..add(serviceFixtures.firstWhere((s) => s.id == 'srv-004'));
  final checkout = scope.read(checkoutControllerProvider.notifier)..setTerm(term);
  if (received != null) checkout.setReceived(received, due: 25000);
  checkout.setExcess(save: saveExcess);
  final id = (await checkout.save())!;
  final data = await scope.read(orderDetailProvider(id).future);
  return data!;
}
