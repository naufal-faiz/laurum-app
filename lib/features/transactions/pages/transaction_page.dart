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
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';

class TransactionPage extends ConsumerWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final customer = ref.watch(customerCatalogProvider).value
        ?.where((c) => c.id == draft.customerId).firstOrNull;
    final balance = draft.customerId == null
        ? 0 : ref.watch(customerBalanceProvider(draft.customerId!)).value ?? 0;
    return FormScaffold(
      title: 'Buat transaksi',
      backLabel: 'Kembali',
      onBack: () => leaveTransaction(context, ref),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Total tagihan (${draft.itemCount} item)', variant: AppTextVariant.label),
          AppText(Formatters.rupiah(draft.total), variant: AppTextVariant.figure),
        ],
      ),
      footer: AppButton(
        'Bayar',
        onPressed: draft.lines.isEmpty ? null : () => context.push('/transaksi/baru/bayar'),
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
              final created = await AddCustomerSheet.show(context, ref, forOrder: true);
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
