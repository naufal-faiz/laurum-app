import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/features/transactions/pages/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

class CustomerPickerSheet extends ConsumerWidget {
  const CustomerPickerSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref) {
    ref.read(customerSearchProvider.notifier).set('');
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Pilih pelanggan',
      subtitle: 'Cari nama atau nomor pelanggan',
      child: const CustomerPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(customerSearchProvider).toLowerCase();
    final customers = ref.watch(customerCatalogProvider);
    final matches = (customers.value ?? [])
        .where(
          (c) => c.name.toLowerCase().contains(query) || c.phone.contains(query),
        )
        .toList();
    return SizedBox(
      height: 520,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: AppSearchField(
              label: 'Cari pelanggan',
              clearLabel: 'Hapus pencarian',
              hint: 'Nama atau nomor pelanggan',
              value: ref.watch(customerSearchProvider),
              onChanged: ref.read(customerSearchProvider.notifier).set,
            ),
          ),
          Expanded(
            child: customers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const EmptyState(
                title: 'Gagal memuat pelanggan',
                icon: AppIcons.alert,
              ),
              data: (_) => matches.isEmpty
                  ? EmptyState(
                      title: 'Pelanggan tidak ditemukan',
                      icon: AppIcons.person,
                      description: 'Tambah pelanggan baru untuk nota ini.',
                      actionLabel: 'Tambah pelanggan baru',
                      onAction: () async {
                        final customer = await AddCustomerSheet.show(context, ref);
                        if (customer == null || !context.mounted) return;
                        ref.read(transactionDraftProvider.notifier).selectCustomer(customer.id);
                        Navigator.of(context).pop();
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      children: [
                        for (final customer in matches)
                          MenuRow(
                            label: customer.name,
                            subtitle: Formatters.telepon(customer.phone),
                            icon: AppIcons.person,
                            onTap: () {
                              ref
                                  .read(transactionDraftProvider.notifier)
                                  .selectCustomer(customer.id);
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
