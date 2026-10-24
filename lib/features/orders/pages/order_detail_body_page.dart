import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/order_customer_page.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/features/orders/pages/order_items_page.dart';
import 'package:laurum/features/orders/pages/order_payment_page.dart';
import 'package:laurum/features/orders/pages/order_summary_page.dart';
import 'package:laurum/features/orders/pages/order_timeline_page.dart';

class OrderDetailBodyPage extends StatelessWidget {
  const OrderDetailBodyPage({
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
      OrderSummaryPage(data: data),
      OrderCustomerPage(data: data, onWhatsApp: onWhatsApp),
      OrderItemsPage(data: data),
      OrderPaymentPage(data: data, onRecord: onRecord),
      OrderTimelinePage(data: data),
    ],
  );
}
