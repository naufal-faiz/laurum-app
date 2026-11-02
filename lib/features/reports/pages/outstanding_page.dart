import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/pages/payment_record_flow.dart';
import 'package:laurum/features/reports/state/outstanding_data.dart';
import 'package:laurum/features/reports/widgets/outstanding_list_section.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

class OutstandingPage extends ConsumerWidget {
  const OutstandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outstanding = ref.watch(outstandingListProvider);
    final filter = ref.watch(outstandingFilterProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppSpacing.appBarHeight),
        child: AppBarSub(
          title: 'Daftar piutang',
          backLabel: 'Kembali',
          onBack: () => context.canPop() ? context.pop() : context.go('/laporan'),
        ),
      ),
      body: outstanding.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
        ),
        error: (_, _) => Center(
          child: EmptyState(
            title: 'Gagal memuat piutang',
            icon: AppIcons.alert,
            actionLabel: 'Coba lagi',
            onAction: () => ref.invalidate(outstandingListProvider),
          ),
        ),
        data: (data) => data.rows.isEmpty
            ? const Center(
                child: EmptyState(
                  title: 'Tidak ada piutang',
                  icon: AppIcons.wallet,
                  description: 'Semua nota sudah lunas.',
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  OutstandingListSection(
                    data: data,
                    filter: filter,
                    now: ref.watch(businessClockProvider)(),
                    onFilter: ref.read(outstandingFilterProvider.notifier).select,
                    onPay: (row) => openOrderPayment(context, ref, row.order.id),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        activeIndex: 2,
        onSelected: (index) => context.go(tabRoutes.keys.elementAt(index)),
        onCreate: () => context.push('/transaksi/baru'),
      ),
    );
  }
}
