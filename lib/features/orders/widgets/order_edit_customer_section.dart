import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class OrderEditCustomerSection extends ConsumerWidget {
  const OrderEditCustomerSection({required this.customerId, super.key});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref
        .watch(customerCatalogProvider)
        .value
        ?.where((customer) => customer.id == customerId)
        .firstOrNull;
    final balance = ref.watch(customerBalanceProvider(customerId)).value ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        const SectionHeader(title: 'Pelanggan'),
        AppCard(
          padding: EdgeInsets.zero,
          child: LockedRow(
            label: customer?.name ?? 'Pelanggan',
            lockLabel: 'Terkunci',
            icon: AppIcons.person,
            description: customer == null
                ? null
                : '${Formatters.telepon(customer.phone)} · '
                      'Saldo tabungan: ${Formatters.rupiah(balance)}',
          ),
        ),
      ],
    );
  }
}
