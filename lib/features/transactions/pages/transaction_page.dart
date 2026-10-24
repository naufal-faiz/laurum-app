import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/transaction_actions.dart';
import 'package:laurum/features/transactions/pages/transaction_customer_page.dart';
import 'package:laurum/features/transactions/pages/transaction_details_page.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/features/transactions/pages/transaction_line_sheet.dart';
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
          const TransactionCustomerPage(),
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
          const TransactionDetailsPage(),
        ],
      ),
    );
  }
}
