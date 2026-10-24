import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/receipt_formatter.dart';
import 'package:laurum/core/domain/receipt_settings.dart';
import 'package:laurum/core/services/repository_providers.dart';

class ReceiptView {
  const ReceiptView({
    required this.order,
    required this.items,
    required this.payments,
    required this.customer,
    required this.business,
    required this.settings,
    required this.savingsBalance,
  });
  final Order order;
  final List<OrderItem> items;
  final List<Payment> payments;
  final Customer customer;
  final BusinessProfile business;
  final ReceiptSettings settings;
  final int savingsBalance;
  List<String> get lines => receiptLines(
    business: business,
    order: order,
    items: items,
    payments: payments,
    customerName: customer.name,
    settings: settings,
    savingsBalance: savingsBalance,
  );
}

final receiptViewProvider = FutureProvider.family<ReceiptView?, String>((ref, id) async {
  final orders = ref.watch(orderRepositoryProvider);
  final order = await orders.getOrderById(id);
  if (order == null) return null;
  final customer = await ref.watch(customerRepositoryProvider).getCustomerById(order.customerId);
  if (customer == null) return null;
  final business = ref.watch(businessRepositoryProvider);
  return ReceiptView(
    order: order,
    items: await orders.getItemsByOrderId(id),
    payments: await orders.getPaymentsByOrderId(id),
    customer: customer,
    business: await business.getProfile(),
    settings: await business.getReceiptSettings(),
    savingsBalance: await ref.watch(savingsRepositoryProvider).getBalance(order.customerId),
  );
});
