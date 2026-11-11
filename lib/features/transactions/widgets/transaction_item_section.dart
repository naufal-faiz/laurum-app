import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

class TransactionItemSection extends StatelessWidget {
  const TransactionItemSection({
    required this.line,
    required this.onEdit,
    required this.onRemove,
    super.key,
  });
  final DraftLine line;
  final VoidCallback onEdit, onRemove;
  @override
  Widget build(BuildContext context) => AppCard(
    rail: AppCardRail.info,
    padding: const EdgeInsets.all(AppSpacing.medium),
    child: Row(
      spacing: AppSpacing.small,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxsmall,
            children: [
              AppText(line.service.name, variant: AppTextVariant.bodyStrong),
              AppText(
                '${line.quantityLabel} × ${Formatters.rupiah(line.service.price)}',
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
              ),
              InlineLink(
                line.service.kind == ServiceKind.kiloan ? 'Ubah berat' : 'Ubah jumlah',
                onTap: onEdit,
              ),
            ],
          ),
        ),
        Flexible(
          child: AppText(
            Formatters.rupiah(line.total),
            variant: AppTextVariant.bodyStrong,
            color: AppColors.primaryInk,
            textAlign: TextAlign.right,
          ),
        ),
        AppIconButton(
          icon: AppIcons.delete,
          label: 'Hapus ${line.service.name}',
          color: AppColors.error,
          onPressed: onRemove,
        ),
      ],
    ),
  );
}
