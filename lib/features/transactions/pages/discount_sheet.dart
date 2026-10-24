import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

typedef DiscountInputState = ({String text, String? error});

class DiscountInput extends Notifier<DiscountInputState> {
  @override
  DiscountInputState build() => (text: '', error: null);
  void start(int current) => state = (text: '$current', error: null);
  void set(String value) => state = (text: value, error: null);
  void error(String message) => state = (text: state.text, error: message);
}

final discountInputProvider = NotifierProvider<DiscountInput, DiscountInputState>(
  DiscountInput.new,
);

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
          final value = int.tryParse(ref.read(discountInputProvider).text.trim());
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
