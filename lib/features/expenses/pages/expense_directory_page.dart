import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/features/expenses/pages/expense_detail_sheet.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/expenses/widgets/expense_list_section.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

class ExpenseDirectoryPage extends ConsumerWidget {
  const ExpenseDirectoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(expenseDirectoryProvider);
    final filter = ref.watch(expenseFilterProvider);
    final profile = ref.watch(businessProfileProvider).value;
    return RootScaffold(
      title: profile?.name ?? 'Laurum',
      accountLabel: 'Usaha dan akun',
      activeIndex: 3,
      syncState: SyncState.values.byName(ref.watch(shellSyncStatusProvider).name),
      onAccount: () => context.go('/lainnya'),
      onTabSelected: (i) => context.go(tabRoutes.keys.elementAt(i)),
      onCreate: () => context.push('/transaksi/baru'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: data.when(
                loading: () => const Center(child: AppText('Memuat pengeluaran...')),
                error: (_, _) => Center(
                  child: EmptyState(
                    title: 'Gagal memuat pengeluaran',
                    icon: AppIcons.alert,
                    actionLabel: 'Coba lagi',
                    onAction: () => ref.invalidate(expenseDirectoryProvider),
                  ),
                ),
                data: (value) => ExpenseListSection(
                  data: value,
                  filter: filter,
                  onFilter: ref.read(expenseFilterProvider.notifier).select,
                  onOpen: (e) => ExpenseDetailSheet.show(context, e, value.category(e.categoryId)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.navCreateSize / 2),
              child: FooterBar(
                child: AppButton(
                  'Catat pengeluaran',
                  icon: AppIcons.add,
                  onPressed: () {
                    ref.invalidate(expenseFormProvider);
                    context.push('/lainnya/pengeluaran/baru');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
