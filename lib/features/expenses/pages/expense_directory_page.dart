import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/features/expenses/pages/expense_detail_sheet.dart';
import 'package:laurum/features/expenses/state/expense_directory.dart';
import 'package:laurum/features/expenses/state/expense_form_controller.dart';
import 'package:laurum/features/expenses/widgets/expense_list_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ExpenseDirectoryPage extends ConsumerWidget {
  const ExpenseDirectoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(expenseDirectoryProvider);
    final filter = ref.watch(expenseFilterProvider);
    final syncState = SyncState.values.byName(ref.watch(shellSyncStatusProvider).name);
    final count = data.value?.expenses.length;
    return SubScaffold(
      title: 'Pengeluaran',
      backLabel: 'Kembali',
      subtitle: count == null ? 'Ringkasan bulan ini' : '$count transaksi bulan ini',
      appBarVariant: AppBarSubVariant.detail,
      trailing: SyncIndicator(state: syncState),
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      fabLabel: 'Catat pengeluaran',
      onFab: () {
        ref.invalidate(expenseFormProvider);
        context.push('/lainnya/pengeluaran/baru');
      },
      body: data.when(
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
    );
  }
}
