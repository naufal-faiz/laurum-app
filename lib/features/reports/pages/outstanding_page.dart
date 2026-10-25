import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/pages/outstanding_data.dart';
import 'package:laurum/features/reports/pages/outstanding_list_page.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

class OutstandingPage extends ConsumerWidget {
  const OutstandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outstanding = ref.watch(outstandingListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piutang'),
        backgroundColor: AppColors.bg,
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
                children: [OutstandingListPage(data: data)],
              ),
      ),
      bottomNavigationBar: const BottomNavBar(activeIndex: 3),
    );
  }
}
