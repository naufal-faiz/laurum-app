import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/customer_picker_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class TransactionCustomerSection extends ConsumerWidget {
  const TransactionCustomerSection({super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const SectionHeader(title: 'Pelanggan'),
        if (customer == null)
          AppButton(
            'Pilih pelanggan',
            variant: AppButtonVariant.actionOutline,
            icon: AppIcons.person,
            onPressed: () => CustomerPickerSheet.show(context, ref),
          )
        else
          MenuRow(
            label: customer.name,
            subtitle: '${Formatters.telepon(customer.phone)} · Saldo ${Formatters.rupiah(balance)}',
            icon: AppIcons.person,
            onTap: () => CustomerPickerSheet.show(context, ref),
          ),
      ],
    );
  }
}
