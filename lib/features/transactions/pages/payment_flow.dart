import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/transactions/state/checkout_notice.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';

Future<void> finishCheckout(BuildContext context, WidgetRef ref, {required bool receipt}) async {
  final id = await ref.read(checkoutControllerProvider.notifier).save();
  if (id == null || !context.mounted) return;
  if (receipt) {
    context.go('/transaksi/nota/$id');
  } else {
    final order = await ref.read(orderRepositoryProvider).getOrderById(id);
    if (!context.mounted) return;
    if (order != null) ref.read(checkoutNoticeProvider.notifier).show(order.orderNo);
    context.go('/antrean');
  }
}
