import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_savings_data.dart';
import 'package:laurum/features/customers/widgets/customer_savings_header_section.dart';
import 'package:laurum/features/customers/widgets/customer_savings_list_section.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class CustomerSavingsHistoryPage extends ConsumerWidget {
  const CustomerSavingsHistoryPage({required this.customerId, super.key});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savings = ref.watch(customerSavingsProvider(customerId));
    return SubScaffold(
      title: 'Riwayat tabungan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/pelanggan'),
      body: savings.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 3; i++) const AppSkeleton(height: 120)],
        ),
        error: (_, _) => Center(
          child: EmptyState(
            title: 'Gagal memuat tabungan',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(customerSavingsProvider(customerId)),
          ),
        ),
        data: (data) => data == null
            ? const Center(
                child: EmptyState(title: 'Pelanggan tidak ditemukan', icon: AppIcons.person),
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  CustomerSavingsHeaderSection(data: data),
                  const SizedBox(height: AppSpacing.screenPadding),
                  if (data.movements.isEmpty)
                    EmptyState(
                      title: 'Belum ada mutasi tabungan',
                      icon: AppIcons.wallet,
                      description: 'Setoran dan pemakaian saldo akan tampil di sini.',
                      actionLabel: data.summary.customer.isActive ? 'Setor tabungan' : null,
                      onAction: data.summary.customer.isActive
                          ? () => context.push('/pelanggan/$customerId/setor')
                          : null,
                    )
                  else
                    CustomerSavingsListSection(data: data),
                ],
              ),
      ),
    );
  }
}
