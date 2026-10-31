import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/orders/pages/order_cancel_flow.dart';
import 'package:laurum/features/orders/pages/order_menu_sheet.dart';
import 'package:laurum/features/orders/pages/order_status_sheet.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';

Future<void> showOrderDetailMenu(BuildContext context, WidgetRef ref, OrderDetailData data) async {
  final action = await OrderMenuSheet.show(context, data);
  if (!context.mounted) return;
  switch (action) {
    case OrderMenuAction.edit:
      await context.push('/order/${data.order.id}/edit');
    case OrderMenuAction.advance:
      await OrderStatusSheet.show(context, data);
    case OrderMenuAction.cancel:
      await confirmCancelOrder(context, ref, data);
    case null:
      break;
  }
}
