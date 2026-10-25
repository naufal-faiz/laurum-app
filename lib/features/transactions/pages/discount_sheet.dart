import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/discount_input.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class DiscountSheet extends ConsumerWidget {
  const DiscountSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref) {
    ref.read(discountInputProvider.notifier).start(ref.read(transactionDraftProvider).discount);
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Atur diskon',
      subtitle: 'Diskon mengurangi total tagihan nota',
      child: const DiscountSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(discountInputProvider);
    final draft = ref.watch(transactionDraftProvider);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppText(
          'Subtotal ${Formatters.rupiah(draft.subtotal)}',
          color: AppColors.ink2,
        ),
        LabeledField(
          label: 'Diskon (Rp)',
          errorText: input.error,
          child: AppTextField(
            label: 'Diskon',
            hint: '0',
            value: input.text,
            keyboardType: TextInputType.number,
            selectAllOnFocus: input.text.isNotEmpty,
            onChanged: ref.read(discountInputProvider.notifier).set,
          ),
        ),
      ],
    );
    return SheetScaffold(
      footer: AppButton(
        'Simpan diskon',
        onPressed: () {
          final subtotal = ref.read(transactionDraftProvider).subtotal;
          final text = ref.read(discountInputProvider).text.trim();
          final value = text.isEmpty ? 0 : int.tryParse(text);
          if (value == null || value < 0 || value > subtotal) {
            ref
                .read(discountInputProvider.notifier)
                .error('Diskon harus antara 0 dan ${Formatters.rupiah(subtotal)}.');
            return;
          }
          ref.read(transactionDraftProvider.notifier).setDiscount(value);
          Navigator.of(context).pop();
        },
      ),
      child: body,
    );
  }
}
