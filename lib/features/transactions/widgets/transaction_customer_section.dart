import 'package:flutter/material.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
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
    spacing: AppSpacing.small,
    children: [
      const SectionHeader(
        title: 'Pelanggan',
        titleColor: AppColors.primaryInk,
        trailing: AppText('Wajib diisi', variant: AppTextVariant.caption, color: AppColors.ink3),
      ),
      if (customer == null) ...[
        AppCard(
          child: Row(
            spacing: AppSpacing.small,
            children: [
              const AppCard(
                style: AppCardStyle.muted,
                padding: EdgeInsets.all(AppSpacing.small),
                child: AppIcon(AppIcons.person, color: AppColors.ink3),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('Belum ada pelanggan', variant: AppTextVariant.bodyStrong),
                    AppText(
                      'Pilih dari daftar atau buat baru',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                    ),
                  ],
                ),
              ),
              AppIconButton(
                icon: AppIcons.next,
                label: 'Pilih pelanggan dari kartu',
                onPressed: onChoose,
              ),
            ],
          ),
        ),
        Row(
          spacing: AppSpacing.cardGap,
          children: [
            Expanded(
              child: AppButton(
                'Pilih pelanggan',
                variant: AppButtonVariant.action,
                onPressed: onChoose,
              ),
            ),
            Expanded(
              child: AppButton(
                'Pelanggan baru',
                variant: AppButtonVariant.actionOutline,
                icon: AppIcons.add,
                onPressed: onCreate,
              ),
            ),
          ],
        ),
      ] else
        AppCard(
          padding: EdgeInsets.zero,
          child: MenuRow(
            label: customer!.name,
            subtitle:
                '${Formatters.telepon(customer!.phone)} · Saldo ${Formatters.rupiah(balance)}',
            icon: AppIcons.person,
            onTap: onChoose,
          ),
        ),
    ],
  );
}
