import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

class RootShellPage extends ConsumerWidget {
  const RootShellPage({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final sync = ref.watch(shellSyncProvider);
    return RootScaffold(
      title: profile.value?.name ?? 'Laurum',
      accountLabel: 'Usaha dan akun',
      activeIndex: navigationShell.currentIndex,
      syncState: sync.hasError
          ? SyncState.gagal
          : SyncState.values.byName(sync.value?.name ?? 'menyimpan'),
      onAccount: () => navigationShell.goBranch(4),
      onTabSelected: navigationShell.goBranch,
      fabLabel: navigationShell.currentIndex == 0 ? 'Transaksi baru' : null,
      onFab: navigationShell.currentIndex == 0 ? () => context.push('/transaksi/baru') : null,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (navigationShell.currentIndex == 0 && !ref.watch(whatsappConnectionProvider)) ...[
              const BannerMessage(
                message: 'WhatsApp terputus. AI berhenti membaca pesan.',
                variant: BannerMessageVariant.warning,
              ),
              AppButton(
                'Hubungkan',
                variant: AppButtonVariant.actionOutline,
                onPressed: () => context.push('/lainnya/ai/hubungkan'),
              ),
            ],
            Expanded(child: navigationShell),
          ],
        ),
      ),
    );
  }
}
