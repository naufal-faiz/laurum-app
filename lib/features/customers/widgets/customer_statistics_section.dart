import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

class CustomerStatisticsSection extends StatelessWidget {
  const CustomerStatisticsSection({required this.summary, super.key});
  final CustomerDirectoryRow summary;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      StatTile(
        label: 'Total belanja',
        value: Formatters.rupiah(summary.historyTotal),
        description: 'Akumulasi',
        compact: true,
      ),
      StatTile(label: 'Frekuensi', value: '${summary.orderCount} order', compact: true),
      StatTile(
        label: 'Piutang aktif',
        value: Formatters.rupiah(summary.debt),
        valueColor: AppColors.error,
        compact: true,
      ),
      StatTile(
        label: 'Saldo tabungan laundry',
        value: Formatters.rupiah(summary.savings),
        valueColor: AppColors.successInk,
        compact: true,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < AppSpacing.touchTarget * 6 ||
            MediaQuery.textScalerOf(context).scale(1) > 1.2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.smallMedium,
          children: stacked
              ? tiles
              : [
                  for (var index = 0; index < tiles.length; index += 2)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.smallMedium,
                        children: [
                          Expanded(child: tiles[index]),
                          Expanded(child: tiles[index + 1]),
                        ],
                      ),
                    ),
                ],
        );
      },
    );
  }
}
