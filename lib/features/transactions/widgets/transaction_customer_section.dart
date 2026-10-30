import 'package:flutter/material.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class TransactionCustomerSection extends StatelessWidget {
  const TransactionCustomerSection({
    required this.customer,
    required this.balance,
    required this.onChoose,
    required this.onCreate,
    super.key,
  });
  final Customer? customer;
  final int balance;
  final VoidCallback onChoose, onCreate;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Pelanggan'),
      if (customer == null)
        Row(
          spacing: AppSpacing.cardGap,
          children: [
            Expanded(
              child: AppButton(
                'Pilih pelanggan',
                variant: AppButtonVariant.actionOutline,
                icon: AppIcons.person,
                onPressed: onChoose,
              ),
            ),
            AppButton(
              'Baru',
              variant: AppButtonVariant.actionOutline,
              icon: AppIcons.add,
              onPressed: onCreate,
            ),
          ],
        )
      else
        MenuRow(
          label: customer!.name,
          subtitle: '${Formatters.telepon(customer!.phone)} · Saldo ${Formatters.rupiah(balance)}',
          icon: AppIcons.person,
          onTap: onChoose,
        ),
    ],
  );
}
