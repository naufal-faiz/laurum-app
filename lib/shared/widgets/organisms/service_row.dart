import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ServiceRow extends StatelessWidget {
  const ServiceRow({
    required this.name,
    required this.kind,
    required this.price,
    required this.durationDays,
    super.key,
    this.isActive = true,
    this.showSwitch = true,
    this.onTap,
    this.onActiveChanged,
  }) : assert(price >= 0 && durationDays >= 0);
  final String name;
  final ServiceKind kind;
  final int price, durationDays;
  final bool isActive, showSwitch;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onActiveChanged;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: AppCard(
      child: Row(
        children: [
          AppIcon(AppIcons.service, color: isActive ? AppColors.primary : AppColors.ink3),
          const SizedBox(width: AppMoleculeTokens.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppMoleculeTokens.smallGap,
              children: [
                Wrap(
                  spacing: AppMoleculeTokens.gap,
                  children: [
                    AppText(name, variant: AppTextVariant.bodyStrong),
                    AppText(
                      kind == ServiceKind.kiloan ? 'Kiloan' : 'Satuan',
                      variant: AppTextVariant.label,
                      color: AppColors.primary,
                    ),
                    if (!isActive)
                      const AppText(
                        'Nonaktif',
                        variant: AppTextVariant.caption,
                        color: AppColors.ink3,
                      ),
                  ],
                ),
                Wrap(
                  spacing: AppMoleculeTokens.gap,
                  children: [
                    AppText(
                      '${Formatters.rupiah(price)} / ${kind == ServiceKind.kiloan ? 'kg' : 'pcs'}',
                      variant: AppTextVariant.bodyStrong,
                      color: AppColors.primary,
                    ),
                    AppText(
                      '$durationDays hari',
                      variant: AppTextVariant.caption,
                      color: AppColors.ink3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showSwitch)
            AppSwitch(value: isActive, label: 'Aktifkan $name', onChanged: onActiveChanged),
        ],
      ),
    ),
  );
}
