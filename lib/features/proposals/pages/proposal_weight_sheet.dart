import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class ProposalWeightSheet extends ConsumerWidget {
  const ProposalWeightSheet({
    required this.id,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String id, value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(proposalDraftProvider(id)).value;
    return SheetScaffold(
      footer: AppButton(
        'Simpan',
        onPressed: draft == null || draft.weightError != null
            ? null
            : () => Navigator.of(context).pop(),
      ),
      child: AppTextField(
        label: 'Berat',
        hint: '0',
        value: draft?.weight ?? value,
        errorText: draft?.weightError,
        dense: true,
        selectAllOnFocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = normalizeProposalWeight(newValue.text);
            return text == newValue.text
                ? newValue
                : newValue.copyWith(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
          }),
        ],
        trailing: const AppText('kg', variant: AppTextVariant.caption, color: AppColors.ink3),
        onChanged: onChanged,
      ),
    );
  }
}
