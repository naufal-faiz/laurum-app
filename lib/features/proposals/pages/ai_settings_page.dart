import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/ai_settings.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/widgets/ai_connection_section.dart';
import 'package:laurum/features/proposals/widgets/ai_preferences_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

class AiSettingsPage extends ConsumerWidget {
  const AiSettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(aiSettingsProvider);
    final actions = ref.read(aiSettingsProvider.notifier);
    final profile = ref.watch(businessProfileProvider).value;
    final connected = ref.watch(whatsappConnectionProvider);
    final history = ref.watch(proposalHistoryProvider).value;
    return RootScaffold(
      title: 'Pengaturan AI & WhatsApp',
      accountLabel: 'Usaha dan akun',
      activeIndex: 3,
      onAccount: () => context.go('/lainnya'),
      onTabSelected: (i) => context.go(['/antrean', '/pelanggan', '/laporan', '/lainnya'][i]),
      onCreate: () => context.push('/transaksi/baru'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding)
              .add(const EdgeInsets.only(bottom: AppDimensions.navCreateSize / 2)),
          children: [
            const SectionHeader(title: 'Pengaturan AI'),
            const NoticeAi(),
            AiConnectionSection(
              connected: connected,
              phone: profile?.phone ?? '',
              onConnect: () => context.push('/lainnya/ai/hubungkan'),
              onCheck: () => context.push('/lainnya/ai/hubungkan'),
              onDisconnect: () async {
                final confirmed = await ConfirmModal.show(
                  context: context,
                  title: 'Putuskan koneksi WhatsApp?',
                  message:
                      'Pembacaan pesan dijeda. Order dan usulan yang sudah ada tetap tersimpan.',
                  confirmLabel: 'Putuskan koneksi',
                  destructive: true,
                  icon: AppIcons.close,
                );
                if (confirmed == true && context.mounted) {
                  ref.read(whatsappConnectionProvider.notifier).setConnected(connected: false);
                }
              },
            ),
            AiPreferencesSection(
              value: preferences,
              onRead: (value) => actions.readMessages(enabled: value),
              onGroups: (value) => actions.ignoreGroups(enabled: value),
              onCancellation: (value) => actions.detectCancellation(enabled: value),
            ),
            const SectionHeader(title: 'Riwayat'),
            MenuRow(
              label: 'Riwayat usulan AI',
              subtitle: history == null
                  ? null
                  : '${history.count(ProposalStatus.disetujui)} disetujui · ${history.count(ProposalStatus.ditolak)} ditolak · ${history.count(ProposalStatus.ditutupOtomatis)} ditutup otomatis',
              icon: AppIcons.time,
              onTap: () => context.push('/lainnya/ai/riwayat'),
            ),
          ],
        ),
      ),
    );
  }
}
