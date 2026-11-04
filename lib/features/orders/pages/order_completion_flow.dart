import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<void> confirmCompleteOrder(BuildContext context, String id) async {
  final confirmed = await ConfirmModal.show(
    context: context,
    title: 'Cetak dan selesaikan?',
    message: 'Buka halaman struk untuk mencetak. Order selesai setelah cetak berhasil.',
    confirmLabel: 'Cetak struk',
    cancelLabel: 'Batal',
    icon: AppIcons.printer,
  );
  if (!context.mounted) return;
  if (confirmed == true) {
    await context.push('/transaksi/nota/$id?complete=1');
  }
}
