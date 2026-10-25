import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/settings/widgets/settings_menu_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider).value;
    return SettingsMenuSection(
      address: profile?.address ?? '',
      connected: ref.watch(whatsappConnectionProvider),
      onLogout: () => _logout(context, ref),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmModal.show(
      context: context,
      title: 'Keluar dari akun?',
      message: 'Data tetap tersimpan online. Anda bisa masuk lagi kapan saja.',
      confirmLabel: 'Keluar',
      icon: AppIcons.lock,
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authServiceProvider).signOut();
    if (context.mounted) context.go('/masuk');
  }
}
