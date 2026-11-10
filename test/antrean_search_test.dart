import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/antrean_search.dart';
import 'package:laurum/features/proposals/state/proposal_demo_accuracy.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  test('accuracy examples only exist in dummy scope', () {
    final real = ProviderContainer();
    final dummy = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(real.dispose);
    addTearDown(dummy.dispose);
    expect(real.read(proposalDemoAccuracyProvider), isEmpty);
    expect(dummy.read(proposalDemoAccuracyProvider)['prop-001'], 92);
  });
  test('search opens, accepts text and clears when closed', () {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    final search = scope.read(antreanSearchProvider.notifier);
    expect(scope.read(antreanSearchProvider).open, isFalse);
    search.toggle();
    search.change('Dedi');
    expect(scope.read(antreanSearchProvider), (open: true, query: 'Dedi'));
    search.toggle();
    expect(scope.read(antreanSearchProvider), (open: false, query: ''));
  });
  test('search matches number, customer and service and intersects status filter', () async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final data = await scope.read(antreanDataProvider.future);
    expect(searchQueueOrders(data, 0, ' a-0142 ').single.id, 'ord-0142');
    expect(searchQueueOrders(data, 0, 'PAK DEDI').map((o) => o.id), contains('ord-0142'));
    expect(searchQueueOrders(data, 0, 'bed cover'), isNotEmpty);
    expect(searchQueueOrders(data, 1, 'A-0142'), isEmpty);
    expect(searchQueueOrders(data, 2, 'A-0142').single.id, 'ord-0142');
    expect(searchQueueOrders(data, 0, 'tidak-ada-hasil-xyz'), isEmpty);
    expect(searchQueueOrders(data, 0, '  '), data.orders);
    expect(searchQueueProposals(data, 'Pak Rudi'), hasLength(1));
    expect(searchQueueProposals(data, 'a-0139'), isNotEmpty);
    expect(searchQueueProposals(data, 'tidak-ada-hasil-xyz'), isEmpty);
    expect(data.orders, hasLength(12));
    expect(data.proposals, hasLength(3));
  });
}
