import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/orders/state/order_completion_controller.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<void> confirmCompleteOrder(BuildContext context, WidgetRef ref, String id) async {
  final confirmed = await ConfirmModal.show(
    context: context,
    title: 'Cetak dan selesaikan?',
    message: 'Order selesai setelah struk berhasil dicetak. Sisa piutang tetap tercatat.',
    confirmLabel: 'Cetak struk',
    cancelLabel: 'Batal',
    icon: AppIcons.printer,
  );
  if (!context.mounted) return;
  final controller = ref.read(orderCompletionProvider(id).notifier);
  if (confirmed == true) {
    await controller.complete();
  } else {
    controller.cancelPrint();
  }
}

Future<void> confirmCompleteWithoutPrint(BuildContext context, WidgetRef ref, String id) async {
  final confirmed = await ConfirmModal.show(
    context: context,
    title: 'Selesaikan tanpa cetak?',
    message: 'Order akan diselesaikan tanpa mencetak struk. Sisa piutang tetap tercatat.',
    confirmLabel: 'Selesaikan tanpa cetak',
    cancelLabel: 'Batal',
  );
  if (confirmed == true && context.mounted) {
    await ref.read(orderCompletionProvider(id).notifier).complete(withoutPrint: true);
  }
}
