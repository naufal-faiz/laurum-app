import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/widgets/antrean_status_section.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';

class AntreanPage extends ConsumerWidget {
  const AntreanPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(antreanDataProvider);
    final filter = ref.watch(antreanFilterProvider);
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
            labels: data.chips,
            selectedIndex: filter,
            onSelected: ref.read(antreanFilterProvider.notifier).select,
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
            onCreate: () => context.push('/transaksi/baru'),
          ),
        for (final order in orders)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: OrderCard(
              key: ValueKey(order.id),
              orderNo: order.orderNo,
              customerName: data.customer(order.customerId),
              summary: data.summary(order),
              total: order.total,
              status: order.status,
              payStatus: data.paymentStatus(order),
              paid: data.paid(order),
              timeLabel: Formatters.jam(order.enteredAt),
              detail: data.detail(order),
              onTap: () => context.push('/order/${order.id}'),
              onAction: actions.pending.contains(order.id)
                  ? null
                  : () => controller.advance(order.id, order.status),
            ),
          ),
        const SizedBox(height: AppSpacing.appBarHeight),
      ],
    );
  }
}
