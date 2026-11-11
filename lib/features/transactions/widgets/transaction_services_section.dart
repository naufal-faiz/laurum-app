import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/widgets/transaction_item_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class TransactionServicesSection extends StatelessWidget {
  const TransactionServicesSection({
    required this.lines,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
    super.key,
  });
  final List<DraftLine> lines;
  final VoidCallback onAdd;
  final ValueChanged<String> onEdit, onRemove;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      SectionHeader(
        title: 'Layanan',
        titleColor: AppColors.primaryInk,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.small,
          children: [
            AppText('${lines.length} item', variant: AppTextVariant.caption, color: AppColors.ink3),
            if (lines.isNotEmpty) InlineLink('+ Tambah', onTap: onAdd),
          ],
        ),
      ),
      if (lines.isEmpty)
        AppCard(
          style: AppCardStyle.muted,
          padding: EdgeInsets.zero,
          child: MenuRow(
            label: 'Belum ada layanan',
            subtitle: 'Tambahkan layanan untuk menghitung total',
            icon: AppIcons.add,
            onTap: onAdd,
          ),
        ),
      for (final line in lines)
        TransactionItemSection(
          key: ValueKey('transaction-line-${line.service.id}'),
          line: line,
          onEdit: () => onEdit(line.service.id),
          onRemove: () => onRemove(line.service.id),
        ),
      if (lines.isNotEmpty)
        AppButton(
          'Tambah layanan lain',
          icon: AppIcons.add,
          variant: AppButtonVariant.actionOutline,
          onPressed: onAdd,
        ),
    ],
  );
}
