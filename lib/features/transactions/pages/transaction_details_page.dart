import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/order_rules.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/features/transactions/pages/discount_sheet.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transactionDraftProvider);
    final estimate = draft.lines.isEmpty
        ? null
        : estimateReady(
            ref.read(businessClockProvider)(),
            draft.lines.map((line) => line.service),
          );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          InfoRow(
            label: 'Estimasi selesai',
            value: estimate == null
                ? 'Pilih layanan'
                : '${Formatters.tanggal(estimate)} - ${Formatters.jam(estimate)}',
          ),
          const AppText(
            'Mengikuti layanan terlama',
            variant: AppTextVariant.caption,
            color: AppColors.ink3,
          ),
          MenuRow(
            label: 'Atur diskon',
            subtitle: Formatters.rupiah(draft.discount),
            icon: AppIcons.info,
            onTap: () => DiscountSheet.show(context, ref),
          ),
          LabeledField(
            label: 'Catatan nota',
            child: AppTextField(
              label: 'Catatan nota',
              hint: 'Misal: pewangi lavender',
              value: draft.note,
              maxLines: 3,
              onChanged: ref.read(transactionDraftProvider.notifier).setNote,
            ),
          ),
        ],
      ),
    );
  }
}
