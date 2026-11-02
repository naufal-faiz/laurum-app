import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/pages/account_edit_sheet.dart';
import 'package:laurum/features/auth/pages/account_flow.dart';
import 'package:laurum/features/auth/pages/change_password_sheet.dart';
import 'package:laurum/features/auth/state/account_edit.dart';
import 'package:laurum/features/auth/state/account_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/account_danger_section.dart';
import 'package:laurum/features/auth/widgets/account_profile_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ManageAccountPage extends ConsumerWidget {
  const ManageAccountPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final data = accountView(ref.watch(authServiceProvider));
    return SubScaffold(
      title: 'Kelola akun',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.screenPadding,
          children: [
            AccountProfileSection(
              data: data,
              busy: session.busy,
              onName: () => AccountEditSheet.show(context, AccountField.name),
              onPhone: () => AccountEditSheet.show(context, AccountField.phone),
              onPassword: () => ChangePasswordSheet.show(context),
            ),
            AccountDangerSection(
              busy: session.busy,
              offline: ref.watch(shellSyncProvider).value == SyncServiceStatus.offline,
              error: session.error,
              onLogout: () => confirmSignOut(context, ref),
              onDelete: () => confirmDeleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
