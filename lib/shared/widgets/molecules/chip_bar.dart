import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';

class ChipBar extends StatelessWidget {
  const ChipBar({required this.labels, super.key, this.selectedIndex, this.onSelected})
    : assert(selectedIndex == null || selectedIndex >= 0);
  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  @override
  Widget build(BuildContext context) {
    assert(selectedIndex == null || selectedIndex! < labels.length);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppMoleculeTokens.gap,
        children: [
          for (var i = 0; i < labels.length; i++)
            AppChip(
              labels[i],
              selected: i == selectedIndex,
              onPressed: onSelected == null ? null : () => onSelected!(i),
            ),
        ],
      ),
    );
  }
}
