import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/widgets/order_customer_section.dart';
import 'package:laurum/features/orders/widgets/order_items_section.dart';
import 'package:laurum/features/orders/widgets/order_payment_section.dart';
import 'package:laurum/features/orders/widgets/order_summary_section.dart';
import 'package:laurum/features/orders/widgets/order_timeline_section.dart';

class OrderDetailBodySection extends StatelessWidget {
  const OrderDetailBodySection({
    required this.data,
    required this.onWhatsApp,
    required this.onRecord,
    super.key,
  });
  final OrderDetailData data;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onRecord;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.screenPadding,
    children: [
      OrderSummarySection(data: data),
      OrderCustomerSection(data: data, onWhatsApp: onWhatsApp),
      OrderItemsSection(data: data),
      OrderPaymentSection(data: data, onRecord: onRecord),
      OrderTimelineSection(data: data),
    ],
  );
}
