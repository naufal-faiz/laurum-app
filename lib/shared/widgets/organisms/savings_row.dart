import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';

class SavingsRow extends StatelessWidget {
  const SavingsRow({
    required this.label,
    required this.timeLabel,
    required this.kind,
    required this.amount,
    required this.balance,
    super.key,
    this.methodLabel,
    this.reference,
    this.note,
  }) : assert(kind == SavingsKind.penyesuaian || amount >= 0),
       assert(balance >= 0);
  final String label, timeLabel;
  final SavingsKind kind;
  final int amount, balance;
  final String? methodLabel, reference, note;
  @override
  Widget build(BuildContext context) {
    final signed = kind == SavingsKind.pakai ? -amount : amount;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppMoleculeTokens.gap,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppIcon(AppIcons.wallet, color: AppColors.primary),
              const SizedBox(width: AppMoleculeTokens.gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(label, variant: AppTextVariant.bodyStrong),
                    AppText(timeLabel, variant: AppTextVariant.caption, color: AppColors.ink3),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppMoleculeTokens.gap,
            children: [
              AppText(
                '${signed > 0 ? '+' : ''}${Formatters.rupiah(signed)}',
                variant: AppTextVariant.section,
                color: signed > 0 ? AppColors.primary : AppColors.ink,
              ),
              AppText('Saldo: ${Formatters.rupiah(balance)}', variant: AppTextVariant.caption),
            ],
          ),
          if (methodLabel != null || reference != null || note != null) const AppDivider(),
          if (methodLabel != null) InfoRow(label: 'Metode', value: methodLabel!),
          if (reference != null) InfoRow(label: 'Referensi', value: reference!),
          if (note != null) InfoRow(label: 'Catatan', value: note!),
        ],
      ),
    );
  }
}
