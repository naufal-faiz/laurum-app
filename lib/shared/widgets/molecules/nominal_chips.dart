import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';

class NominalChips extends StatelessWidget {
  const NominalChips({
    required this.amounts,
    super.key,
    this.onSelected,
    this.selectedAmount,
    this.increment = true,
  });
  final List<int> amounts;
  final int? selectedAmount;
  final bool increment;
  final ValueChanged<int>? onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppMoleculeTokens.gap,
    runSpacing: AppMoleculeTokens.gap,
    children: [
      for (final amount in amounts)
        AppChip(
          '${increment ? '+' : ''}${Formatters.rupiah(amount)}',
          selected: amount == selectedAmount,
          onPressed: onSelected == null ? null : () => onSelected!(amount),
        ),
    ],
  );
}
