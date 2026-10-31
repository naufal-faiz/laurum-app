import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_directory_actions_section.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

class CustomerDirectoryListSection extends StatelessWidget {
  const CustomerDirectoryListSection({
    required this.rows,
    required this.filter,
    required this.search,
    required this.onFilter,
    required this.onSearch,
    required this.onImport,
    required this.onAdd,
    required this.onOpen,
    required this.onContact,
    super.key,
  });
  final List<CustomerDirectoryRow> rows;
  final int filter;
  final String search;
  final ValueChanged<int> onFilter;
  final ValueChanged<String> onSearch;
  final VoidCallback onImport, onAdd;
  final ValueChanged<String> onOpen, onContact;

  @override
  Widget build(BuildContext context) {
    final visible = filterCustomers(rows, filter: filter, search: search);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        SectionHeader(title: 'Pelanggan', subtitle: '${rows.length} pelanggan'),
        const SizedBox(height: AppSpacing.cardGap),
        CustomerDirectoryActionsSection(onImport: onImport, onAdd: onAdd),
        const SizedBox(height: AppSpacing.cardGap),
        if (rows.isNotEmpty) ...[
          AppSearchField(
            label: 'Nama pelanggan',
            clearLabel: 'Hapus pencarian',
            hint: 'Cari nama atau nomor WhatsApp...',
            value: search,
            onChanged: onSearch,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          ChipBar(
            labels: [
              'Semua (${rows.length})',
              'Ada piutang (${rows.where((r) => r.debt > 0).length})',
              'Punya tabungan (${rows.where((r) => r.savings > 0).length})',
            ],
            selectedIndex: filter,
            onSelected: onFilter,
          ),
          const SizedBox(height: AppSpacing.cardGap),
        ],
        if (visible.isEmpty)
          EmptyState(
            title: rows.isEmpty ? 'Belum ada pelanggan' : 'Tidak ditemukan',
            description: rows.isEmpty
                ? 'Tambah manual atau impor dari kontak HP.'
                : 'Coba nama atau nomor lain.',
            icon: AppIcons.customers,
          ),
        for (final row in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: CustomerRow(
              name: row.customer.name,
              phone: row.customer.phone,
              initials: customerInitials(row.customer.name),
              orderCount: row.orderCount,
              historyTotal: row.historyTotal,
              savings: row.savings,
              outstanding: row.debt,
              paid: row.paid,
              onTap: () => onOpen(row.customer.id),
              onContact: row.customer.phone.isEmpty ? null : () => onContact(row.customer.phone),
            ),
          ),
      ],
    );
  }
}
