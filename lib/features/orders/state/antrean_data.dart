import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/proposal.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/repository_providers.dart';

class AntreanData {
  const AntreanData(this.orders, this.proposals, this.customers, this.items, this.payments);
  final List<Order> orders;
  final List<Proposal> proposals;
  final Map<String, Customer> customers;
  final Map<String, List<OrderItem>> items;
  final List<Payment> payments;
  List<String> get chips => [
    'Semua ${orders.length}',
    'Jemput ${visibleOrders(1).length}',
    'Proses ${visibleOrders(2).length}',
    'Siap ${visibleOrders(3).length}',
    'Perlu dicek ${proposals.length}',
  ];
  List<Order> visibleOrders(int filter) =>
      filter == 4 ? [] : orders.where((o) => filter == 0 || o.status.index == filter - 1).toList();
  String customer(String? id) => customers[id]?.name ?? 'Pelanggan tidak tersedia';
  int paid(Order order) => paidAmount(payments, orderId: order.id);
  PayStatus paymentStatus(Order order) => payStatus(total: order.total, paid: paid(order));
  String summary(Order order) => (items[order.id] ?? [])
      .map((item) {
        final quantity = switch (item.unit) {
          'kg' => Formatters.berat(item.qtyMilli),
          'pcs' => Formatters.jumlah(item.qtyMilli ~/ 1000),
          _ => '',
        };
        return '${item.serviceName} $quantity'.trim();
      })
      .join(' • ');
  String detail(Order order) => order.status == OrderStatus.menungguJemput
      ? 'Sisa ${Formatters.rupiah(order.total - paid(order))}'
      : 'Siap ${Formatters.tanggal(order.estimatedAt, ringkas: true)}';
}

final antreanDataProvider = FutureProvider<AntreanData>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  final customers = ref.watch(customerRepositoryProvider);
  final proposals = ref.watch(proposalRepositoryProvider);
  final orders =
      (await repository.getOrders())
          .where((o) => o.status != OrderStatus.selesai && o.status != OrderStatus.dibatalkan)
          .toList()
        ..sort((a, b) => b.enteredAt.compareTo(a.enteredAt));
  final pending = await proposals.getProposals(status: ProposalStatus.menunggu);
  final customerList = await customers.getCustomers(includeInactive: true);
  final items = <String, List<OrderItem>>{};
  for (final order in orders) {
    items[order.id] = await repository.getItemsByOrderId(order.id);
  }
  return AntreanData(
    orders,
    pending,
    {for (final c in customerList) c.id: c},
    items,
    await repository.getAllPayments(),
  );
});
