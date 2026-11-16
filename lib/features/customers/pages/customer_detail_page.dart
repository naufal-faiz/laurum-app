import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_edit_sheet.dart';
import 'package:laurum/features/customers/state/customer_detail_data.dart';
import 'package:laurum/features/customers/state/customer_order_expansion.dart';
import 'package:laurum/features/customers/widgets/customer_orders_section.dart';
import 'package:laurum/features/customers/widgets/customer_profile_section.dart';
import 'package:laurum/features/customers/widgets/customer_savings_section.dart';
import 'package:laurum/features/sync/state/data_refresh_actions.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({required this.customerId, super.key});
  final String customerId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(customerDetailProvider(customerId));
    final summary = snapshot.value?.summary;
    return SubScaffold(
      onRefresh: () => ref
          .read(dataRefreshActionsProvider.notifier)
          .refresh(
            extra: [customerDetailProvider(customerId).future],
          ),
      refreshScrollable: snapshot.value != null || snapshot.isLoading,
      title: 'Detail pelanggan',
      subtitle: summary == null ? null : '${summary.customer.name} · ${summary.orderCount} order',
      appBarVariant: AppBarSubVariant.detail,
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/pelanggan'),
      body: snapshot.when(
        skipLoadingOnReload: true,
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
        ),
        error: (_, _) => Center(
          child: EmptyState(
            title: 'Gagal memuat pelanggan',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(customerDetailProvider(customerId)),
          ),
        ),
        data: (data) => data == null
            ? const Center(
                child: EmptyState(title: 'Pelanggan tidak ditemukan', icon: AppIcons.person),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xlarge,
                  vertical: AppSpacing.medium,
                ),
                children: [
                  CustomerProfileSection(
                    summary: data.summary,
                    onWhatsApp: () => ref
                        .read(externalLauncherProvider)
                        .launchWhatsApp(
                          phone: data.summary.customer.phone,
                          message: '',
                        ),
                    onEdit: () => CustomerEditSheet.show(context, ref, data.summary.customer),
                  ),
                  const SizedBox(height: AppSpacing.screenPadding),
                  CustomerSavingsSection(
                    data: data,
                    onDeposit: () => context.push('/pelanggan/$customerId/setor'),
                    onHistory: () => context.push('/pelanggan/$customerId/tabungan'),
                  ),
                  const SizedBox(height: AppSpacing.screenPadding),
                  CustomerOrdersSection(
                    data: data,
                    showAll: ref.watch(customerOrderExpansionProvider).contains(customerId),
                    onShowAll: () =>
                        ref.read(customerOrderExpansionProvider.notifier).showAll(customerId),
                    onOpen: (order) => context.push('/order/${order.id}'),
                  ),
                ],
              ),
      ),
    );
  }
}
