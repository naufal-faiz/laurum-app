import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/pages/report_range_flow.dart';
import 'package:laurum/features/reports/state/report_custom_range.dart';
import 'package:laurum/features/reports/state/report_export.dart';
import 'package:laurum/features/reports/state/report_period.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/reports/widgets/report_body_section.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/period_tabs.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ReportPage extends ConsumerWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(reportViewProvider);
    final data = snapshot.asData?.value;
    final exporting = ref.watch(reportExportProvider);
    final custom = ref.watch(reportCustomRangeProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              SectionHeader(
                title: 'Laporan',
                actionLabel: 'Ekspor Excel',
                onAction: data == null || data.isEmpty || exporting.busy
                    ? null
                    : () => ref.read(reportExportProvider.notifier).export(data),
              ),
              if (exporting.message != null)
                BannerMessage(
                  message: exporting.message!,
                  variant: exporting.failed
                      ? BannerMessageVariant.error
                      : BannerMessageVariant.info,
                ),
              PeriodTabs(
                labels: [
                  ...reportPeriodLabels.take(3),
                  custom == null
                      ? 'Pilih tanggal'
                      : Formatters.rentangTanggal(
                          custom.start,
                          custom.end.subtract(const Duration(days: 1)),
                        ),
                ],
                selectedIndex: ref.watch(reportPeriodProvider),
                onSelected: exporting.busy ? null : (index) => _select(context, ref, index),
              ),
            ],
          ),
        ),
        Expanded(
          child: snapshot.when(
            skipLoadingOnReload: false,
            skipLoadingOnRefresh: false,
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
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _select(BuildContext context, WidgetRef ref, int index) async {
    if (index == 3) {
      await pickReportRange(context, ref);
    } else {
      ref.read(reportExportProvider.notifier).reset();
      ref.read(reportPeriodProvider.notifier).select(index);
    }
  }
}
