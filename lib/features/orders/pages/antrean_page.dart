import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/antrean_filter_view.dart';
import 'package:laurum/features/orders/widgets/antrean_orders_section.dart';
import 'package:laurum/features/orders/widgets/antrean_status_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';

class AntreanPage extends ConsumerWidget {
  const AntreanPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(antreanDataProvider);
    final useStatus = ref.watch(businessProfileProvider).value?.useOrderStatus ?? true;
    final filters = AntreanFilterView(ref.watch(antreanFilterProvider), useOrderStatus: useStatus);
    final filter = filters.selectedValue;
    final actions = ref.watch(antreanActionsProvider);
    final controller = ref.read(antreanActionsProvider.notifier);
    final data = snapshot.value;
    if (data == null) {
      return AntreanStatusSection(
        loading: snapshot.isLoading,
        error: snapshot.hasError,
        onRetry: () => ref.invalidate(antreanDataProvider),
      );
    }
    final orders = data.visibleOrders(filter);
    final showProposals = filter == 0 || filter == 4;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        SectionHeader(
          title: 'Antrean aktif',
          subtitle: '${data.orders.length} order aktif',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardGap),
          child: ChipBar(
            labels: [for (final value in filters.values) data.chips[value]],
            selectedIndex: filters.selectedIndex,
            onSelected: (index) =>
                ref.read(antreanFilterProvider.notifier).select(filters.values[index]),
          ),
        ),
        if (actions.error != null)
          BannerMessage(message: actions.error!, variant: BannerMessageVariant.error),
        if (showProposals && data.proposals.isNotEmpty) ...[
          SectionHeader(
            title: 'Perlu dicek',
            actionLabel: 'Lihat semua (${data.proposals.length})',
            onAction: () => ref.read(antreanFilterProvider.notifier).select(4),
          ),
          for (final proposal in data.proposals)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
              child: ProposalCard(
                customerName: data.customer(proposal.customerId),
                summary: proposal.sourceText,
                timeLabel: Formatters.jam(proposal.createdAt),
                needsReview: true,
                onApprove: () => context.push('/antrean/usulan/${proposal.id}'),
                onReject: actions.pending.contains(proposal.id)
                    ? null
                    : () => controller.reject(proposal.id),
              ),
            ),
        ],
        if (orders.isNotEmpty) const SectionHeader(title: 'Sedang berjalan'),
        if (orders.isEmpty && (!showProposals || data.proposals.isEmpty))
          AntreanStatusSection(
            filtered: filter != 0,
            reviewOnly: filter == 4,
            onCreate: () => context.push('/transaksi/baru'),
          ),
        AntreanOrdersSection(
          data: data,
          orders: orders,
          pending: actions.pending,
          useOrderStatus: useStatus,
          onOpen: (order) => context.push('/order/${order.id}'),
          onAdvance: (order) => controller.advance(order.id, order.status),
        ),
        const SizedBox(height: AppSpacing.appBarHeight),
      ],
    );
  }
}
