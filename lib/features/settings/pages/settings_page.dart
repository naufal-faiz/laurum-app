import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/auth/pages/account_flow.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/settings/state/order_status_setting.dart';
import 'package:laurum/features/settings/widgets/settings_menu_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider).value;
    final setting = ref.watch(orderStatusSettingProvider);
    final session = ref.watch(authSessionProvider);
    return SettingsMenuSection(
      address: profile?.address ?? '',
      connected: ref.watch(whatsappConnectionProvider),
      useOrderStatus: profile?.useOrderStatus ?? true,
      error: setting.error ?? session.error,
      email: ref.watch(authServiceProvider).email,
      accountBusy: session.busy,
      onOrderStatusChanged: profile == null || setting.saving
          ? null
          : (enabled) => ref.read(orderStatusSettingProvider.notifier).setEnabled(enabled: enabled),
      onNavigate: (path) => context.push(path),
      onLogout: () => confirmSignOut(context, ref),
    );
  }
}
