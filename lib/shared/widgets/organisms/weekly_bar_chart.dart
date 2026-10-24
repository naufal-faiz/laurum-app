import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    required this.labels,
    required this.amounts,
    super.key,
    this.title = 'Aktivitas omzet harian',
    this.averageLabel,
    this.peakLabel,
  });

  final List<String> labels;
  final List<int?> amounts;
  final String title;
  final String? averageLabel, peakLabel;

  @override
  Widget build(BuildContext context) {
    final max = amounts.whereType<int>().fold<int>(0, (value, item) => item > value ? item : value);
    final peakIndex = amounts.indexOf(max);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppMoleculeTokens.gap,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(title: title, subtitle: averageLabel),
              ),
              if (peakLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.chipIdle,
                    borderRadius: AppRadius.chip,
                  ),
                  child: AppText(peakLabel!, variant: AppTextVariant.label),
                ),
            ],
          ),
          SizedBox(
            height: 128 + 160 * (textScale - 1).clamp(0, 4).toDouble(),
            child: Row(
              spacing: 10,
              children: [
                for (var i = 0; i < labels.length; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: AppMoleculeTokens.labelGap,
                      children: [
                        AppText(
                          amounts[i] == null ? '—' : _compact(amounts[i]!),
                          variant: AppTextVariant.caption,
                          color: AppColors.ink2,
                        ),
                        Expanded(
                          child: amounts[i] == null
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 40,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      spacing: 4,
                                      children: [
                                        for (var line = 0; line < 4; line++)
                                          Container(height: 4, color: AppColors.borderStrong),
                                      ],
                                    ),
                                  ),
                                )
                              : FractionallySizedBox(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: max == 0 ? 0 : amounts[i]! / max,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: AppRadius.input,
                                    ),
                                  ),
                                ),
                        ),
                        AppText(
                          labels[i],
                          variant: AppTextVariant.label,
                          color: i == peakIndex ? AppColors.ink : AppColors.ink2,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _compact(int amount) => '${(amount / 1000).round()}k';
