import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

class ServiceTypeSection extends StatelessWidget {
  const ServiceTypeSection({required this.kind, required this.onKind, super.key});
  final ServiceKind kind;
  final ValueChanged<int> onKind;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      for (final (index, label, unit, icon) in [
        (0, 'Kiloan', 'per kg', AppIcons.bag),
        (1, 'Satuan', 'per pcs', AppIcons.service),
      ])
        SelectionTile(
          label: label,
          subtitle: unit,
          icon: icon,
          compact: true,
          selected: index == (kind == ServiceKind.kiloan ? 0 : 1),
          onPressed: () => onKind(index),
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth < AppSpacing.touchTarget * 6 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.small,
              children: tiles,
            )
          : Row(
              spacing: AppSpacing.small,
              children: [for (final tile in tiles) Expanded(child: tile)],
            ),
    );
  }
}
