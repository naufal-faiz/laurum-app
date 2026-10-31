import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

Future<void> confirmSignOut(BuildContext context, WidgetRef ref) async {
  final pending = ref.read(syncServiceProvider).pendingChanges;
  final confirmed = await ConfirmModal.show(
    context: context,
    title: 'Keluar dari akun?',
    message: pending > 0
        ? 'Masih ada $pending perubahan belum tersinkron. Data di HP dipertahankan. Keluar sekarang?'
        : 'Data di HP tetap tersimpan. Anda bisa masuk lagi kapan saja.',
    confirmLabel: 'Keluar',
    destructive: true,
    icon: AppIcons.logout,
  );
  if (confirmed == true && context.mounted) {
    await ref.read(authSessionProvider.notifier).signOut();
  }
}

Future<void> confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
  final first = await ConfirmModal.show(
    context: context,
    title: 'Hapus akun?',
    message: 'Seluruh data akun dan data di HP akan dihapus. Tindakan ini tidak dapat dibatalkan.',
    confirmLabel: 'Lanjutkan',
    destructive: true,
    icon: AppIcons.delete,
  );
  if (first != true || !context.mounted) return;
  final second = await ConfirmModal.show(
    context: context,
    title: 'Hapus akun secara permanen?',
    message:
        'Konfirmasi terakhir: akun beserta data pelanggan, order dan catatan usaha akan dihapus.',
    confirmLabel: 'Hapus permanen',
    destructive: true,
    icon: AppIcons.delete,
  );
  if (second == true && context.mounted) {
    await ref.read(authSessionProvider.notifier).deleteAccount();
  }
}
