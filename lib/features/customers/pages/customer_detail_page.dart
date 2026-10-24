import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_detail_data.dart';
import 'package:laurum/features/customers/pages/customer_orders_page.dart';
import 'package:laurum/features/customers/pages/customer_profile_page.dart';
import 'package:laurum/features/customers/pages/customer_savings_page.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({required this.customerId, super.key});
  final String customerId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => SubScaffold(
    title: 'Detail pelanggan',
    backLabel: 'Kembali',
    onBack: () => context.canPop() ? context.pop() : context.go('/pelanggan'),
    body: ref
        .watch(customerDetailProvider(customerId))
        .when(
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
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: [
                    CustomerProfilePage(summary: data.summary),
                    const SizedBox(height: AppSpacing.screenPadding),
                    CustomerSavingsPage(data: data),
                    const SizedBox(height: AppSpacing.screenPadding),
                    CustomerOrdersPage(data: data),
                  ],
                ),
        ),
  );
}
