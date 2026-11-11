import 'package:flutter/material.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/organisms/customer_contact_card.dart';

class OrderCustomerSection extends StatelessWidget {
  const OrderCustomerSection({required this.data, required this.onWhatsApp, super.key});
  final OrderDetailData data;
  final VoidCallback? onWhatsApp;
  @override
  Widget build(BuildContext context) => CustomerContactCard(
    name: data.customer.name,
    phone: data.customer.phone,
    initials: customerInitials(data.customer.name),
    address: data.customer.address,
    showContact: data.customer.phone.trim().isNotEmpty,
    onContact: onWhatsApp,
  );
}
