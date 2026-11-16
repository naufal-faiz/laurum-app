import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/pages/report_range_flow.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_export.dart';
import 'package:laurum/features/reports/state/report_orders_controller.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/reports/widgets/report_body_section.dart';
import 'package:laurum/features/reports/widgets/report_header_section.dart';
import 'package:laurum/features/reports/widgets/report_sync_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/sync/state/data_refresh_actions.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ReportPage extends ConsumerWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(reportViewProvider);
    final data = snapshot.value;
    final orders = ref.watch(reportOrdersProvider).value;
    final exporting = ref.watch(reportExportProvider);
    final custom = ref.watch(reportCustomRangeProvider);
    final useStatus = ref.watch(businessProfileProvider).value?.useOrderStatus ?? true;
    final period = ref.watch(reportPeriodProvider);
    final labels = reportPeriodTabs(custom);
    final narrow =
        MediaQuery.sizeOf(context).width < AppSpacing.touchTarget * 7 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.2;
    final onExport =
        data == null || data.isEmpty || exporting.busy || snapshot.isLoading || snapshot.hasError
        ? null
        : () => ref.read(reportExportProvider.notifier).export(data, orders: orders);
    return SubScaffold(
      onRefresh: ref.read(dataRefreshActionsProvider.notifier).refresh,
      refreshScrollable: !snapshot.hasError || data != null,
      title: 'Laporan',
      backLabel: 'Kembali',
      subtitle: 'Ringkasan usaha · ${labels[period]}',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      appBarVariant: AppBarSubVariant.detail,
      trailing: narrow
          ? null
          : AppButton(
              'Excel',
              icon: AppIcons.download,
              size: AppButtonSize.small,
              variant: AppButtonVariant.actionOutline,
              onPressed: onExport,
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportSyncSection(status: ref.watch(shellSyncStatusProvider)),
          ReportHeaderSection(
            labels: labels,
            selectedIndex: period,
            onExport: onExport,
            onPeriod: exporting.busy ? null : (index) => selectReportPeriod(context, ref, index),
            message: exporting.message,
            failed: exporting.failed,
          ),
          Expanded(
            child: snapshot.when(
              skipLoadingOnReload: data?.period == period && (period != 3 || data?.range == custom),
              skipLoadingOnRefresh: true,
              loading: () => ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
              ),
              error: (_, _) => Center(
                child: EmptyState(
                  title: 'Gagal memuat laporan',
                  icon: AppIcons.alert,
                  description: 'Data periode ini belum dapat dimuat.',
                  actionLabel: 'Coba lagi',
                  onAction: () => ref.invalidate(reportViewProvider),
                ),
              ),
              data: (value) => ReportBodySection(
                data: value,
                onOutstanding: () => context.push('/laporan/piutang'),
                orders: orders,
                orderFilter: ref.watch(reportOrdersFilterProvider),
                orderSearch: ref.watch(reportOrdersSearchProvider),
                useOrderStatus: useStatus,
                onOrderSearch: ref.read(reportOrdersSearchProvider.notifier).set,
                onOrderFilter: ref.read(reportOrdersFilterProvider.notifier).select,
                onOpenOrder: (order) => context.push('/order/${order.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
