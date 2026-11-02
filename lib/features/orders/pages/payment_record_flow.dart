import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/features/orders/pages/payment_record_sheet.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';

Future<void> openOrderPayment(
  BuildContext context,
  WidgetRef ref,
  String id, {
  bool completeOnPayment = false,
}) async {
  ref.invalidate(orderDetailProvider(id));
  final data = await ref.read(orderDetailProvider(id).future);
  if (!context.mounted || data == null || !data.canRecord) return;
  await PaymentRecordSheet.show(context, ref, data, completeOnPayment: completeOnPayment);
}

Future<void> advanceQueueOrder(BuildContext context, WidgetRef ref, Order order, int paid) async {
  if (order.status == OrderStatus.siap && isCompletionHeld(order, paid)) {
    await openOrderPayment(context, ref, order.id, completeOnPayment: true);
  } else {
    await ref.read(antreanActionsProvider.notifier).advance(order.id, order.status);
  }
}
