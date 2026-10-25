import 'package:flutter/material.dart';
import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/nota_history_data.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/date_group_header.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/organisms/nota_card.dart';

class NotaHistoryListSection extends StatelessWidget {
  const NotaHistoryListSection({
    required this.data,
    required this.filter,
    required this.search,
    required this.today,
    required this.onSearch,
    required this.onFilter,
    required this.onOpen,
    super.key,
  });
  final NotaHistoryData data;
  final int filter;
  final String search;
  final DateTime today;
  final ValueChanged<String> onSearch;
  final ValueChanged<int> onFilter;
  final ValueChanged<Order> onOpen;

  @override
  Widget build(BuildContext context) {
    final orders = filterNota(data, filter: filter, search: search, today: today);
    final rows = <Widget>[];
    DateTime? lastDay;
    for (final order in orders) {
      final day = DateTime(order.enteredAt.year, order.enteredAt.month, order.enteredAt.day);
      if (day != lastDay) {
        final sameDay = day.year == today.year && day.month == today.month && day.day == today.day;
        rows.add(
          DateGroupHeader(
            label: sameDay ? 'Hari ini - ${Formatters.tanggal(day)}' : Formatters.tanggal(day),
          ),
        );
        lastDay = day;
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
          child: NotaCard(
            orderNo: order.orderNo,
            customerName: data.customer(order.customerId),
            summary: data.summary(order),
            total: order.total,
            status: order.status,
            payStatus: data.paymentStatus(order),
            paid: data.paid(order),
            timeLabel: Formatters.jam(order.enteredAt),
            onTap: () => onOpen(order),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        if (data.orders.isNotEmpty) ...[
          AppSearchField(
            label: 'Nama pelanggan',
            clearLabel: 'Hapus pencarian',
            hint: 'Cari nomor nota atau nama pelanggan',
            value: search,
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          ChipBar(
            labels: const ['Semua', 'Hari ini', 'Belum lunas', 'Selesai', 'Dibatalkan'],
            selectedIndex: filter,
            onSelected: onFilter,
          ),
          const SizedBox(height: AppSpacing.cardGap),
        ],
        if (orders.isEmpty)
          EmptyState(
            title: data.orders.isEmpty ? 'Belum ada nota' : 'Nota tidak ditemukan',
            icon: AppIcons.receipt,
            description: data.orders.isEmpty
                ? 'Nota yang Anda buat akan tampil di sini.'
                : 'Coba kata kunci atau filter lain.',
          )
        else
          ...rows,
      ],
    );
  }
}
