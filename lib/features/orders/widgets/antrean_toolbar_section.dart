import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

class AntreanToolbarSection extends StatelessWidget {
  const AntreanToolbarSection({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.onFilter,
    super.key,
  });
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback? onFilter;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardGap),
    child: Row(
      spacing: AppSpacing.small,
      children: [
        Expanded(
          child: ChipBar(labels: labels, selectedIndex: selectedIndex, onSelected: onSelected),
        ),
        if (onFilter != null)
          AppIconButton(icon: AppIcons.filter, label: 'Filter status', onPressed: onFilter),
      ],
    ),
  );
}
