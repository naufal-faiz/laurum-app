import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/proposals/state/proposal_history.dart';
import 'package:laurum/features/proposals/widgets/proposal_history_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

class ProposalHistoryPage extends ConsumerWidget {
  const ProposalHistoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(proposalHistoryProvider);
    final filter = ref.watch(proposalHistoryFilterProvider);
    return RootScaffold(
      title: 'Riwayat usulan AI',
      accountLabel: 'Usaha dan akun',
      activeIndex: 3,
      onAccount: () => context.go('/lainnya'),
      onTabSelected: (i) => context.go(['/antrean', '/pelanggan', '/laporan', '/lainnya'][i]),
      onCreate: () => context.push('/transaksi/baru'),
      body: SafeArea(
        top: false,
        child: history.when(
          loading: () => const Center(child: AppText('Memuat riwayat...')),
          error: (_, _) => EmptyState(
            title: 'Gagal memuat riwayat',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(proposalHistoryProvider),
          ),
          data: (value) => ProposalHistorySection(
            history: value,
            filter: filter,
            onFilter: ref.read(proposalHistoryFilterProvider.notifier).select,
            onOpen: (p) => context.push('/antrean/usulan/${p.id}'),
          ),
        ),
      ),
    );
  }
}
