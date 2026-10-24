import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';

class NotaHistoryData {
  const NotaHistoryData({
    required this.orders,
    required this.customers,
    required this.items,
    required this.payments,
  });
  final List<Order> orders;
  final Map<String, Customer> customers;
  final Map<String, List<OrderItem>> items;
  final List<Payment> payments;

  String customer(String? id) => customers[id]?.name ?? 'Pelanggan tidak tersedia';
  int paid(Order order) => paidAmount(payments, orderId: order.id);
  PayStatus paymentStatus(Order order) => payStatus(total: order.total, paid: paid(order));
  String summary(Order order) => (items[order.id] ?? []).map(orderItemSummary).join(' • ');
}

List<Order> filterNota(
  NotaHistoryData data, {
  required int filter,
  required String search,
  required DateTime today,
}) {
  final query = search.trim().toLowerCase();
  bool todayOnly(DateTime value) =>
      value.year == today.year && value.month == today.month && value.day == today.day;
  return data.orders.where((order) {
    final matchesText =
        query.isEmpty ||
        order.orderNo.toLowerCase().contains(query) ||
        data.customer(order.customerId).toLowerCase().contains(query);
    final matchesFilter = switch (filter) {
      1 => todayOnly(order.enteredAt),
      2 => data.paymentStatus(order) != PayStatus.lunas && order.status != OrderStatus.dibatalkan,
      3 => order.status == OrderStatus.selesai,
      4 => order.status == OrderStatus.dibatalkan,
      _ => true,
    };
    return matchesText && matchesFilter;
  }).toList();
}

final notaHistoryProvider = FutureProvider<NotaHistoryData>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  final customers = await ref.watch(customerRepositoryProvider).getCustomers(includeInactive: true);
  final orders = (await repository.getOrders()).toList()
    ..sort((a, b) => b.enteredAt.compareTo(a.enteredAt));
  final items = <String, List<OrderItem>>{};
  for (final order in orders) {
    items[order.id] = await repository.getItemsByOrderId(order.id);
  }
  return NotaHistoryData(
    orders: orders,
    customers: {for (final customer in customers) customer.id: customer},
    items: items,
    payments: await repository.getAllPayments(),
  );
});
