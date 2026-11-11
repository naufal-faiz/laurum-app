import 'package:flutter/material.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/customer_contact_card.dart';

class TransactionCustomerSection extends StatelessWidget {
  const TransactionCustomerSection({
    required this.customer,
    required this.balance,
    required this.onChoose,
    required this.onCreate,
    required this.onImport,
    super.key,
  });
  final Customer? customer;
  final int balance;
  final VoidCallback onChoose, onCreate, onImport;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      SectionHeader(
        title: 'Pelanggan',
        titleColor: AppColors.primaryInk,
        actionLabel: customer == null ? null : 'Ganti',
        onAction: customer == null ? null : onChoose,
        trailing: customer == null
            ? const AppText('Wajib diisi', variant: AppTextVariant.caption, color: AppColors.ink3)
            : null,
      ),
      if (customer == null)
        AppCard(
          padding: EdgeInsets.zero,
          child: MenuRow(
            label: 'Belum ada pelanggan',
            subtitle: 'Pilih dari daftar atau buat baru',
            icon: AppIcons.person,
            onTap: onChoose,
          ),
        )
      else
        CustomerContactCard(
          name: customer!.name,
          phone: customer!.phone,
          showContact: false,
          badge: AppText(
            'Saldo ${Formatters.rupiah(balance)}',
            variant: AppTextVariant.caption,
            color: AppColors.primaryInk,
          ),
        ),
      Row(
        spacing: AppSpacing.cardGap,
        children: [
          Expanded(
            child: AppButton(
              'Impor kontak',
              variant: AppButtonVariant.action,
              onPressed: onImport,
            ),
          ),
          Expanded(
            child: AppButton(
              'Pelanggan baru',
              variant: AppButtonVariant.actionOutline,
              onPressed: onCreate,
            ),
          ),
        ],
      ),
    ],
  );
}
