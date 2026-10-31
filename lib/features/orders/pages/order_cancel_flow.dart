import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/orders/state/order_detail_controller.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<bool> confirmCancelOrder(
  BuildContext context,
  WidgetRef ref,
  OrderDetailData data, {
  bool simplified = false,
}) async {
  final confirmed = await ConfirmModal.show(
    context: context,
    title: simplified ? 'Hapus nota ini?' : 'Batalkan order ${data.order.orderNo}?',
    message: 'Order tidak dihitung di laporan. Riwayatnya tetap tersimpan.',
    confirmLabel: simplified ? 'Ya, hapus nota' : 'Ya, batalkan order',
    destructive: true,
    icon: AppIcons.alert,
  );
  if (confirmed != true || !context.mounted) return false;
  return ref.read(orderActionsProvider.notifier).cancel(data);
}
