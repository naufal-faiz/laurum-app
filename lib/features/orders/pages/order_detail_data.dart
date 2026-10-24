import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_event.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/repository_providers.dart';

const orderStatusLabels = ['Menunggu jemput', 'Diproses', 'Siap', 'Selesai', 'Dibatalkan'];

String orderStatusLabel(OrderStatus status) => orderStatusLabels[status.index];

String nextStatusLabel(OrderStatus status) => switch (status) {
  OrderStatus.menungguJemput => 'Tandai dijemput',
  OrderStatus.diproses => 'Tandai siap',
  OrderStatus.siap => 'Serahkan',
  _ => 'Selesai',
};

String orderQuantityLabel(OrderItem item) => switch (item.unit) {
  'kg' => Formatters.berat(item.qtyMilli),
  'pcs' => Formatters.jumlah(item.qtyMilli ~/ 1000),
  _ => '',
};

String orderItemSummary(OrderItem item) => '${item.serviceName} ${orderQuantityLabel(item)}'.trim();

String customerInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return '';
  if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
  return '${words.first[0]}${words.last[0]}'.toUpperCase();
}

class ActivityEntry {
  const ActivityEntry(this.label, this.at);
  final String label;
  final DateTime at;
}

class OrderDetailData {
  const OrderDetailData({
    required this.order,
    required this.customer,
    required this.items,
    required this.payments,
    required this.events,
  });
  final Order order;
  final Customer customer;
  final List<OrderItem> items;
  final List<Payment> payments;
  final List<OrderEvent> events;
  int get paid => paidAmount(payments, orderId: order.id);
  int get outstanding => (order.total - paid).clamp(0, order.total);
  PayStatus get paymentStatus => payStatus(total: order.total, paid: paid);
  String get paymentLabel => switch (paymentStatus) {
    PayStatus.belumBayar => 'Belum bayar',
    PayStatus.dp => 'DP ${Formatters.rupiah(paid)}',
    PayStatus.lunas => 'Lunas',
  };
  bool get isFinal => order.status == OrderStatus.selesai || order.status == OrderStatus.dibatalkan;
  bool get fromWhatsapp => order.source == OrderSource.whatsappAi;
  List<ActivityEntry> get activity => [
    for (final event in events) ActivityEntry(eventLabel(event), event.occurredAt),
    if (!events.any((event) => event.kind == 'created'))
      ActivityEntry('Order dibuat', order.enteredAt),
  ]..sort((a, b) => b.at.compareTo(a.at));
}

String eventLabel(OrderEvent event) => switch (event.kind) {
  'created' => 'Order dibuat',
  'status' =>
    'Status diubah menjadi '
        '${event.toStatus == null ? '' : orderStatusLabel(event.toStatus!)}',
  'cancelled' => 'Order dibatalkan',
  'edited' => 'Nota diperbarui',
  'payment' => 'Pembayaran dicatat',
  _ => event.note.isEmpty ? 'Aktivitas' : event.note,
};

final orderDetailProvider = FutureProvider.family<OrderDetailData?, String>((ref, id) async {
  final orders = ref.watch(orderRepositoryProvider);
  final order = await orders.getOrderById(id);
  if (order == null) return null;
  final customer = await ref.watch(customerRepositoryProvider).getCustomerById(order.customerId);
  if (customer == null) return null;
  return OrderDetailData(
    order: order,
    customer: customer,
    items: await orders.getItemsByOrderId(id),
    payments: await orders.getPaymentsByOrderId(id),
    events: await orders.getEventsByOrderId(id),
  );
});
