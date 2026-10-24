import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/molecules/nominal_chips.dart';

enum NumpadVariant { standard, decimal }

class Numpad extends StatelessWidget {
  const Numpad({
    required this.onKey,
    super.key,
    this.variant = NumpadVariant.standard,
    this.amounts = const [],
    this.selectedAmount,
    this.onNominalSelected,
  });

  final ValueChanged<AppNumpadKeyValue> onKey;
  final NumpadVariant variant;
  final List<int> amounts;
  final int? selectedAmount;
  final ValueChanged<int>? onNominalSelected;

  @override
  Widget build(BuildContext context) {
    final lastRow = variant == NumpadVariant.decimal
        ? [AppNumpadKeyValue.decimal, AppNumpadKeyValue.zero, AppNumpadKeyValue.backspace]
        : [AppNumpadKeyValue.tripleZero, AppNumpadKeyValue.zero, AppNumpadKeyValue.backspace];
    final rows = <List<AppNumpadKeyValue>>[
      [AppNumpadKeyValue.one, AppNumpadKeyValue.two, AppNumpadKeyValue.three],
      [AppNumpadKeyValue.four, AppNumpadKeyValue.five, AppNumpadKeyValue.six],
      [AppNumpadKeyValue.seven, AppNumpadKeyValue.eight, AppNumpadKeyValue.nine],
      lastRow,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        if (amounts.isNotEmpty)
          NominalChips(
            amounts: amounts,
            selectedAmount: selectedAmount,
            onSelected: onNominalSelected,
          ),
        for (final keys in rows)
          Row(
            spacing: AppMoleculeTokens.gap,
            children: [
              for (final key in keys)
                Expanded(
                  child: AppNumpadKey(
                    key,
                    onPressed: () => onKey(key),
                    semanticLabel: key == AppNumpadKeyValue.backspace ? 'Hapus digit' : null,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
