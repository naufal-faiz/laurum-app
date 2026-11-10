import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/antrean_filter_sheet.dart';
import 'package:laurum/features/orders/pages/payment_record_flow.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/antrean_filter_view.dart';
import 'package:laurum/features/orders/state/antrean_search.dart';
import 'package:laurum/features/orders/widgets/antrean_orders_section.dart';
import 'package:laurum/features/orders/widgets/antrean_proposals_section.dart';
import 'package:laurum/features/orders/widgets/antrean_status_section.dart';
import 'package:laurum/features/orders/widgets/antrean_toolbar_section.dart';
import 'package:laurum/features/proposals/state/proposal_demo_accuracy.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/checkout_notice.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

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
    final notice = ref.watch(checkoutNoticeProvider);
    final search = ref.watch(antreanSearchProvider);
    if (data == null) {
      return AntreanStatusSection(
        loading: snapshot.isLoading,
        error: snapshot.hasError,
        onRetry: () => ref.invalidate(antreanDataProvider),
      );
    }
    final orders = searchQueueOrders(data, filter, search.query);
    final proposals = searchQueueProposals(data, search.query);
    final showProposals = filter == 0 || filter == 4;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        if (notice != null) BannerMessage(message: notice),
        if (search.open)
          AppSearchField(
            key: const ValueKey('antrean-search'),
            label: 'Cari antrean',
            clearLabel: 'Hapus pencarian',
            hint: 'Nama, nomor nota, atau layanan',
            value: search.query,
            autofocus: true,
            onChanged: ref.read(antreanSearchProvider.notifier).change,
          ),
        AntreanToolbarSection(
          labels: [data.chips[filter == 4 ? 0 : filter], data.chips[4]],
          selectedIndex: filter == 4 ? 1 : 0,
          onSelected: (index) =>
              ref.read(antreanFilterProvider.notifier).select(index == 1 ? 4 : 0),
          onFilter: useStatus ? () => AntreanFilterSheet.show(context) : null,
        ),
        if (actions.error != null)
          BannerMessage(message: actions.error!, variant: BannerMessageVariant.error),
        if (showProposals && proposals.isNotEmpty)
          AntreanProposalsSection(
            data: data,
            proposals: filter == 0 && search.query.trim().isEmpty
                ? proposals.take(2).toList()
                : proposals,
            pending: actions.pending,
            demoAccuracy: ref.watch(proposalDemoAccuracyProvider),
            onSeeAll: () => ref.read(antreanFilterProvider.notifier).select(4),
            onOpen: (proposal) => context.push('/antrean/usulan/${proposal.id}'),
            onReject: (proposal) => controller.reject(proposal.id),
          ),
        if (orders.isNotEmpty) const SectionHeader(title: 'Antrean berjalan'),
        if (orders.isEmpty && (!showProposals || proposals.isEmpty))
          AntreanStatusSection(
            filtered: filter != 0,
            reviewOnly: filter == 4,
            searching: search.query.trim().isNotEmpty,
            onCreate: () => context.push('/transaksi/baru'),
          ),
        AntreanOrdersSection(
          data: data,
          orders: orders,
          pending: actions.pending,
          useOrderStatus: useStatus,
          onOpen: (order) => context.push('/order/${order.id}'),
          onAdvance: (order) => advanceQueueOrder(context, ref, order, data.paid(order)),
        ),
        const SizedBox(height: AppSpacing.appBarHeight),
      ],
    );
  }
}
