import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/pages/report_view.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

class ReportBodyPage extends StatelessWidget {
  const ReportBodyPage({required this.data, super.key});
  final ReportView data;
  @override
  Widget build(BuildContext context) {
    final daily = data.daily;
    final amounts = daily?.whereType<int>().toList() ?? <int>[];
    final average = amounts.isEmpty ? 0 : amounts.fold(0, (sum, n) => sum + n) ~/ amounts.length;
    final peak = amounts.fold(0, (max, value) => value > max ? value : max);
    const dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return ListView(
      key: ValueKey(data.period),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        if (data.isEmpty)
          const EmptyState(
            title: 'Belum ada data periode ini',
            description: 'Laporan terisi setelah ada nota pada periode yang dipilih.',
            icon: AppIcons.reports,
          ),
        if (!data.isEmpty || data.totals.activeOutstanding > 0 || data.totals.savingsBalance > 0)
          ReportSummary(
            totals: data.totals,
            expenseSummary: 'Operasional usaha',
            unpaidCount: data.unpaidCount,
            onOutstandingTap: () => context.push('/laporan/piutang'),
          ),
        if (!data.isEmpty) ...[
          const SizedBox(height: AppSpacing.screenPadding),
          if (daily != null) ...[
            WeeklyBarChart(
              labels: data.dayLabels,
              amounts: daily,
              averageLabel: 'Rata-rata ${Formatters.rupiah(average)}/hari',
            ),
            if (data.period == 1 && peak > 0) AppText('Puncak: ${dayNames[daily.indexOf(peak)]}'),
          ] else
            const BannerMessage(message: 'Rincian omzet harian belum tersedia untuk periode ini.'),
          const SizedBox(height: AppSpacing.screenPadding),
          if (data.services != null)
            TopServices(services: data.services!, totalRevenue: data.totals.revenue)
          else
            const BannerMessage(
              message: 'Rincian layanan terlaris belum tersedia untuk periode ini.',
            ),
        ],
      ],
    );
  }
}
