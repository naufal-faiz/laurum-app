import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_directory_controller.dart';
import 'package:laurum/features/customers/pages/customer_directory_data.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/customer_row.dart';

class CustomerDirectoryListPage extends ConsumerWidget {
  const CustomerDirectoryListPage({required this.rows, super.key});
  final List<CustomerDirectoryRow> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(customerDirectoryFilterProvider);
    final search = ref.watch(customerDirectorySearchProvider);
    final visible = filterCustomers(rows, filter: filter, search: search);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        SectionHeader(
          title: 'Pelanggan',
          subtitle: '${rows.length} pelanggan',
          actionLabel: 'Impor kontak',
          onAction: () => context.push('/pelanggan/impor'),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        if (rows.isNotEmpty) ...[
          AppSearchField(
            label: 'Nama pelanggan',
            clearLabel: 'Hapus pencarian',
            hint: 'Cari nama atau nomor WhatsApp...',
            value: search,
            onChanged: ref.read(customerDirectorySearchProvider.notifier).set,
          ),
          const SizedBox(height: AppSpacing.cardGap),
          ChipBar(
            labels: [
              'Semua (${rows.length})',
              'Ada piutang (${rows.where((r) => r.debt > 0).length})',
              'Punya tabungan (${rows.where((r) => r.savings > 0).length})',
            ],
            selectedIndex: filter,
            onSelected: ref.read(customerDirectoryFilterProvider.notifier).select,
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
              onTap: () => context.push('/pelanggan/${row.customer.id}'),
              onContact: row.customer.phone.isEmpty
                  ? null
                  : () => ref
                        .read(externalLauncherProvider)
                        .launchUrl('tel:${row.customer.phone.replaceAll(RegExp(r'\D'), '')}'),
            ),
          ),
      ],
    );
  }
}
