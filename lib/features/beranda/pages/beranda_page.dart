import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/beranda/state/beranda_view.dart';
import 'package:laurum/features/beranda/widgets/beranda_frequent_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_header_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_queue_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_stats_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_welcome_section.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

/// Home dashboard of frame `LAURUM · Beranda`; data comes from existing providers.
class BerandaPage extends ConsumerWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final antrean = ref.watch(antreanDataProvider);
    final customers = ref.watch(customerDirectoryProvider);
    final report = ref.watch(reportViewProvider);
    final view = BerandaView.from(
      businessName: profile.value?.name ?? 'Laurum',
      orders: antrean.value?.orders ?? const [],
      customers: customers.value ?? const [],
      revenue: report.value?.totals.revenue ?? 0,
      daily: report.value?.daily ?? const [],
      now: ref.watch(businessClockProvider)(),
    );
    final loading = antrean.isLoading || customers.isLoading || report.isLoading;
    final error = antrean.hasError || customers.hasError || report.hasError;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xlarge,
        AppSpacing.medium,
        AppSpacing.xlarge,
        AppSpacing.xxlarge * 3,
      ),
      children: [
        const BerandaHeaderSection(),
        const SizedBox(height: AppSpacing.large),
        if (loading)
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.cardGap),
              child: AppSkeleton(height: 112),
            )
        else if (error)
          EmptyState(
            title: 'Gagal memuat beranda',
            icon: AppIcons.alert,
            description: 'Data usaha belum dapat dimuat.',
            actionLabel: 'Coba lagi',
            onAction: () {
              ref.invalidate(antreanDataProvider);
              ref.invalidate(customerDirectoryProvider);
              ref.invalidate(reportViewProvider);
            },
          )
        else ...[
          BerandaWelcomeSection(
            businessName: view.businessName,
            onManageQueue: () => context.go('/antrean'),
          ),
          const SizedBox(height: AppSpacing.large),
          BerandaQueueSection(
            total: view.total,
            updatedLabel: view.updatedLabel,
            stages: view.stages,
          ),
          const SizedBox(height: AppSpacing.large),
          BerandaStatsSection(
            savedCustomers: view.savedCustomers,
            newCustomers: view.newCustomers,
            initials: view.initials,
            revenue: Formatters.rupiah(view.revenue),
            daily: view.daily,
          ),
          const SizedBox(height: AppSpacing.large),
          BerandaFrequentSection(
            rows: view.frequent,
            onOpen: (id) => context.push('/pelanggan/$id'),
            onSeeAll: () => context.go('/pelanggan'),
          ),
        ],
      ],
    );
  }
}
