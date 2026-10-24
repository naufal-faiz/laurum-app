import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_status_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class CustomerRow extends StatelessWidget {
  const CustomerRow({
    required this.name,
    required this.phone,
    super.key,
    this.initials,
    this.orderCount = 0,
    this.historyTotal = 0,
    this.savings = 0,
    this.outstanding = 0,
    this.paid = 0,
    this.onTap,
    this.onContact,
  }) : assert(
         orderCount >= 0 && historyTotal >= 0 && savings >= 0 && outstanding >= 0 && paid >= 0,
       );
  final String name, phone;
  final String? initials;
  final int orderCount, historyTotal, savings, outstanding, paid;
  final VoidCallback? onTap, onContact;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppMoleculeTokens.gap,
        children: [
          Row(
            children: [
              AppAvatar(initials: initials),
              const SizedBox(width: AppMoleculeTokens.gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(name, variant: AppTextVariant.bodyStrong),
                    AppText(Formatters.telepon(phone), color: AppColors.ink2),
                  ],
                ),
              ),
              AppIconButton(AppIcons.phone, label: 'Hubungi $name', onPressed: onContact),
            ],
          ),
          if (outstanding > 0)
            Wrap(
              spacing: AppMoleculeTokens.gap,
              children: [
                AppStatusText(
                  paid > 0
                      ? 'DP ${Formatters.rupiah(paid)}'
                      : 'Belum bayar ${Formatters.rupiah(outstanding)}',
                  variant: paid > 0 ? AppStatusTextVariant.dp : AppStatusTextVariant.belumBayar,
                ),
                if (paid > 0)
                  AppText(
                    'Sisa ${Formatters.rupiah(outstanding)}',
                    variant: AppTextVariant.caption,
                  ),
              ],
            ),
          if (savings > 0)
            AppText(
              'Tabungan ${Formatters.rupiah(savings)}',
              variant: AppTextVariant.label,
              color: AppColors.primary,
            ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.chipIdle,
              borderRadius: AppRadius.input,
            ),
            child: Padding(
              padding: AppMoleculeTokens.syncPadding,
              child: AppText(
                '$orderCount order • Total: ${Formatters.rupiah(historyTotal)}',
                variant: AppTextVariant.caption,
                color: AppColors.ink2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
