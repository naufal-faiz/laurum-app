import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/expenses/state/expense_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

class ExpenseAmountSection extends StatelessWidget {
  const ExpenseAmountSection({
    required this.draft,
    required this.onNominal,
    required this.onKey,
    super.key,
  });
  final ExpenseDraft draft;
  final ValueChanged<String> onNominal;
  final ValueChanged<AppNumpadKeyValue> onKey;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      LabeledField(
        label: 'Jumlah pengeluaran (Rp)',
        child: AppTextField(
          label: 'Jumlah pengeluaran',
          hint: '0',
          value: draft.text,
          errorText: draft.nominalError,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          selectAllOnFocus: true,
          enabled: !draft.busy,
          onChanged: onNominal,
        ),
      ),
      Numpad(onKey: onKey),
    ],
  );
}
