import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_directory_controller.dart';
import 'package:laurum/features/customers/pages/customer_directory_data.dart';
import 'package:laurum/features/customers/pages/customer_directory_list_page.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';

class CustomerDirectoryPage extends ConsumerWidget {
  const CustomerDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(customerDirectoryProvider);
    final rows = snapshot.value;
    return Column(
      children: [
        Expanded(
          child: rows != null
              ? CustomerDirectoryListPage(rows: rows)
              : snapshot.hasError
              ? Center(
                  child: EmptyState(
                    title: 'Gagal memuat data',
                    icon: AppIcons.alert,
                    description: 'Periksa koneksi dan coba lagi.',
                    actionLabel: 'Coba lagi',
                    onAction: () => ref.invalidate(customerDirectoryProvider),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: [
                    for (var i = 0; i < 4; i++)
                      const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.cardGap),
                        child: AppSkeleton(height: AppSpacing.touchTarget * 2),
                      ),
                  ],
                ),
        ),
        FooterBar(
          child: AppButton(
            'Pelanggan baru',
            onPressed: () async {
              final customer = await AddCustomerSheet.show(
                Navigator.of(context, rootNavigator: true).context,
                ref,
                forOrder: false,
              );
              if (customer == null || !context.mounted) return;
              ref.read(customerDirectoryFilterProvider.notifier).select(0);
              ref.read(customerDirectorySearchProvider.notifier).set('');
            },
          ),
        ),
      ],
    );
  }
}
