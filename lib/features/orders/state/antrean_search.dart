import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';

typedef AntreanSearchState = ({bool open, String query});
final antreanSearchProvider = NotifierProvider<AntreanSearch, AntreanSearchState>(
  AntreanSearch.new,
);

class AntreanSearch extends Notifier<AntreanSearchState> {
  @override
  AntreanSearchState build() => (open: false, query: '');
  void toggle() => state = (open: !state.open, query: '');
  void change(String value) => state = (open: true, query: value);
}

List<Order> searchQueueOrders(AntreanData data, int filter, String query) {
  final term = query.trim().toLowerCase();
  return data
      .visibleOrders(filter)
      .where(
        (order) =>
            term.isEmpty ||
            '${data.customer(order.customerId)} ${order.orderNo} ${data.summary(order)}'
                .toLowerCase()
                .contains(term),
      )
      .toList();
}

List<Proposal> searchQueueProposals(AntreanData data, String query) {
  final term = query.trim().toLowerCase();
  if (term.isEmpty) return data.proposals;
  final numbers = {for (final order in data.orders) order.id: order.orderNo};
  return data.proposals.where((proposal) {
    final customer = proposal.customerId == null
        ? proposal.customerName
        : data.customer(proposal.customerId);
    return '$customer ${proposal.sourceText} ${numbers[proposal.orderId] ?? ''}'
        .toLowerCase()
        .contains(term);
  }).toList();
}
