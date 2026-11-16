import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/features/reports/widgets/report_orders_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/organisms/report_summary.dart';
import 'package:laurum/shared/widgets/organisms/top_services.dart';
import 'package:laurum/shared/widgets/organisms/weekly_bar_chart.dart';

class ReportBodySection extends StatelessWidget {
  const ReportBodySection({
    required this.data,
    required this.onOutstanding,
    super.key,
    this.orders,
    this.orderFilter = 0,
    this.orderSearch = '',
    this.useOrderStatus = true,
    this.onOrderSearch,
    this.onOrderFilter,
    this.onOpenOrder,
  });
  final ReportView data;
  final VoidCallback onOutstanding;
  final ReportOrdersData? orders;
  final int orderFilter;
  final String orderSearch;
  final bool useOrderStatus;
  final ValueChanged<String>? onOrderSearch;
  final ValueChanged<int>? onOrderFilter;
  final ValueChanged<Order>? onOpenOrder;
  @override
  Widget build(BuildContext context) {
    final daily = data.daily;
    return ListView(
      key: ValueKey((data.period, data.range)),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge)
          .add(const EdgeInsets.only(bottom: AppDimensions.navCreateSize / 2)),
      children: [
        if (!data.isEmpty ||
            (data.period != 3 &&
                (data.totals.activeOutstanding > 0 || data.totals.savingsBalance > 0)))
          ReportSummary(
            totals: data.totals,
            expenseSummary: 'Operasional usaha',
            unpaidCount: data.unpaidCount,
            onOutstandingTap: onOutstanding,
          ),
        if (!data.isEmpty) ...[
          if (daily != null || data.period != 2) const SizedBox(height: AppSpacing.mediumLarge),
          if (daily != null) ...[
            WeeklyBarChart(
              labels: data.dayLabels,
              amounts: daily,
              averageLabel: 'Rata-rata ${Formatters.rupiah(data.dailyAverage)}/hari',
            ),
            if (data.peakDayName != null) AppText('Puncak: ${data.peakDayName}'),
          ] else if (data.period != 2)
            const BannerMessage(
              message: 'Grafik harian ditampilkan untuk rentang hingga 7 hari.',
            ),
          const SizedBox(height: AppSpacing.mediumLarge),
          if (data.services != null)
            TopServices(services: data.services!, totalRevenue: data.totals.revenue)
          else
            const BannerMessage(
              message: 'Rincian layanan terlaris belum tersedia untuk periode ini.',
            ),
        ],
        if (orders != null || data.isEmpty) ...[
          const SizedBox(height: AppSpacing.mediumLarge),
          ReportOrdersSection(
            data:
                orders ??
                const ReportOrdersData(orders: [], customers: {}, items: {}, payments: []),
            emptyReport: data.isEmpty,
            range: data.range,
            filter: orderFilter,
            search: orderSearch,
            useOrderStatus: useOrderStatus,
            onSearch: onOrderSearch ?? (_) {},
            onFilter: onOrderFilter ?? (_) {},
            onOpen: onOpenOrder ?? (_) {},
          ),
        ],
      ],
    );
  }
}
