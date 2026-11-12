import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/beranda/state/beranda_view.dart';
import 'package:laurum/features/beranda/widgets/beranda_frequent_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_queue_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_stats_section.dart';
import 'package:laurum/features/beranda/widgets/beranda_welcome_section.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_period.dart';
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
    final report = ref.watch(weeklyReportViewProvider);
    final view = BerandaView.from(
      businessName: profile.value?.name ?? 'Laurum',
      orders: antrean.value?.orders ?? const [],
      items: antrean.value?.items ?? const {},
      customers: customers.value ?? const [],
      revenue: report.value?.totals.revenue ?? 0,
      daily: report.value?.daily ?? const [],
      now: ref.watch(businessClockProvider)(),
    );
    // A refresh keeps the previous value, so only the very first read may show
    // placeholders. Reacting to `isLoading` alone blanks the dashboard on every
    // sync and reads as flicker.
    final loading = [
      antrean,
      customers,
      report,
    ].any((value) => value.isLoading && !value.hasValue);
    final error = [antrean, customers, report].any((value) => value.hasError && !value.hasValue);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.large,
        AppSpacing.medium,
        AppSpacing.large,
        AppSpacing.xxlarge * 3,
      ),
      children: [
        if (loading)
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.cardGap),
              child: AppSkeleton(height: AppSpacing.appBarHeight + AppSpacing.touchTarget),
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
              ref.invalidate(weeklyReportViewProvider);
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
            onRevenue: () {
              ref.read(reportPeriodProvider.notifier).select(1);
              context.push('/laporan');
            },
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
