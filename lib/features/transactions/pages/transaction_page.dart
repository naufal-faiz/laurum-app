import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/add_customer_sheet.dart';
import 'package:laurum/features/transactions/pages/customer_picker_sheet.dart';
import 'package:laurum/features/transactions/pages/transaction_leave_flow.dart';
import 'package:laurum/features/transactions/pages/transaction_line_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/features/transactions/widgets/transaction_customer_section.dart';
import 'package:laurum/features/transactions/widgets/transaction_details_section.dart';
import 'package:laurum/features/transactions/widgets/transaction_footer_section.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final customer = ref
        .watch(customerCatalogProvider)
        .value
        ?.where((c) => c.id == draft.customerId)
        .firstOrNull;
    final balance = draft.customerId == null
        ? 0
        : ref.watch(customerBalanceProvider(draft.customerId!)).value ?? 0;
    return FormScaffold(
      title: 'Buat Transaksi',
      subtitle: 'Order baru · nota otomatis',
      appBarVariant: AppBarSubVariant.detail,
      padding: const EdgeInsets.all(AppSpacing.xlarge),
      trailing: const AppBadge('Draft', variant: AppBadgeVariant.menungguJemput),
      backLabel: 'Kembali',
      onBack: () => leaveTransaction(context, ref),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
        child: TransactionFooterSection(
          total: draft.total,
          itemCount: draft.itemCount,
          onPay: draft.lines.isEmpty ? null : () => context.push('/transaksi/baru/bayar'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          TransactionCustomerSection(
            customer: customer,
            balance: balance,
            onChoose: () => CustomerPickerSheet.show(context, ref),
            onCreate: () async {
              final created = await AddCustomerSheet.show(context, ref);
              if (created == null || !context.mounted) return;
              ref.invalidate(customerCatalogProvider);
              ref.read(transactionDraftProvider.notifier).selectCustomer(created.id);
            },
          ),
          SectionHeader(
            title: 'Layanan',
            subtitle: '${draft.itemCount} layanan di nota',
          ),
          AppButton(
            draft.lines.isEmpty ? 'Pilih layanan' : 'Tambah layanan lain',
            variant: AppButtonVariant.actionOutline,
            icon: AppIcons.add,
            onPressed: () => context.push('/transaksi/baru/layanan'),
          ),
          for (final line in draft.lines)
            MenuRow(
              label: line.service.name,
              subtitle: '${line.quantityLabel} · ${Formatters.rupiah(line.total)}',
              icon: AppIcons.service,
              onTap: () => TransactionLineSheet.show(context, ref, line.service.id),
            ),
          const TransactionDetailsSection(),
        ],
      ),
    );
  }
}
