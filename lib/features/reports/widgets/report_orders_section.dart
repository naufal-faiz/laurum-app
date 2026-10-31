import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/reports/state/report_orders_data.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/date_group_header.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/order_card.dart';

class ReportOrdersSection extends StatelessWidget {
  const ReportOrdersSection({
    required this.data,
    required this.range,
    required this.filter,
    required this.search,
    required this.useOrderStatus,
    required this.onSearch,
    required this.onFilter,
    required this.onOpen,
    super.key,
  });
  final ReportOrdersData data;
  final ReportRange range;
  final int filter;
  final String search;
  final bool useOrderStatus;
  final ValueChanged<String> onSearch;
  final ValueChanged<int> onFilter;
  final ValueChanged<Order> onOpen;

  @override
  Widget build(BuildContext context) {
    final orders = filterReportOrders(data, filter: filter, search: search, range: range);
    final inRange = filterReportOrders(data, filter: 0, search: '', range: range);
    final rows = <Widget>[];
    DateTime? lastDay;
    for (final order in orders) {
      final day = DateTime(order.enteredAt.year, order.enteredAt.month, order.enteredAt.day);
      if (day != lastDay) {
        rows.add(DateGroupHeader(label: Formatters.tanggal(day)));
        lastDay = day;
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
          child: OrderCard(
            orderNo: order.orderNo,
            customerName: data.customer(order.customerId),
            summary: data.summary(order),
            total: order.total,
            status: order.status,
            statusLabel: orderStatusLabel(order.status, useOrderStatus: useOrderStatus),
            payStatus: data.paymentStatus(order),
            paid: data.paid(order),
            timeLabel: Formatters.jam(order.enteredAt),
            compact: true,
            showAction: false,
            onTap: () => onOpen(order),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Nota (${orders.length})'),
        const SizedBox(height: AppSpacing.cardGap),
        if (inRange.isNotEmpty) ...[
          AppSearchField(
            label: 'Nama pelanggan',
            clearLabel: 'Hapus pencarian',
            hint: 'Cari nomor nota atau nama pelanggan',
            value: search,
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          ChipBar(
            labels: const ['Semua', 'Belum lunas', 'Selesai', 'Dibatalkan'],
            selectedIndex: filter,
            onSelected: onFilter,
          ),
          const SizedBox(height: AppSpacing.cardGap),
        ],
        if (orders.isEmpty)
          EmptyState(
            title: inRange.isEmpty ? 'Belum ada nota periode ini' : 'Nota tidak ditemukan',
            icon: AppIcons.receipt,
            description: inRange.isEmpty
                ? 'Nota pada periode ini akan tampil di sini.'
                : 'Coba kata kunci atau filter lain.',
          )
        else
          ...rows,
      ],
    );
  }
}
