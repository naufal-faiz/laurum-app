import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_directory_controller.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_directory_list_section.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class CustomerDirectoryPage extends ConsumerWidget {
  const CustomerDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(customerDirectoryProvider);
    final rows = snapshot.value;
    if (rows != null) {
      return CustomerDirectoryListSection(
        rows: rows,
        filter: ref.watch(customerDirectoryFilterProvider),
        search: ref.watch(customerDirectorySearchProvider),
        onFilter: ref.read(customerDirectoryFilterProvider.notifier).select,
        onSearch: ref.read(customerDirectorySearchProvider.notifier).set,
        onImport: () => context.push('/pelanggan/impor'),
        onAdd: () => _addCustomer(context, ref),
        onOpen: (id) => context.push('/pelanggan/$id'),
        onContact: (phone) => ref
            .read(externalLauncherProvider)
            .launchUrl('tel:${phone.replaceAll(RegExp(r'\D'), '')}'),
      );
    }
    if (snapshot.hasError) {
      return Center(
        child: EmptyState(
          title: 'Gagal memuat data',
          icon: AppIcons.alert,
          description: 'Periksa koneksi dan coba lagi.',
          actionLabel: 'Coba lagi',
          onAction: () => ref.invalidate(customerDirectoryProvider),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        for (var i = 0; i < 4; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.cardGap),
            child: AppSkeleton(height: AppSpacing.touchTarget * 2),
          ),
      ],
    );
  }

  Future<void> _addCustomer(BuildContext context, WidgetRef ref) async {
    final customer = await AddCustomerSheet.show(
      Navigator.of(context, rootNavigator: true).context,
      ref,
      forOrder: false,
    );
    if (customer == null || !context.mounted) return;
    ref.read(customerDirectoryFilterProvider.notifier).select(0);
    ref.read(customerDirectorySearchProvider.notifier).set('');
  }
}
