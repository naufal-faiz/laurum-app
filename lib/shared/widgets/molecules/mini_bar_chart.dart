import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';

/// Compact bar chart: one bar per day, the last bar highlighted.
class MiniBarChart extends StatelessWidget {
  const MiniBarChart({required this.amounts, super.key, this.height = 32});

  final List<int?> amounts;
  final double height;

  @override
  Widget build(BuildContext context) {
    final max = amounts.whereType<int>().fold<int>(0, (a, b) => b > a ? b : a);
    final last = amounts.lastIndexWhere((amount) => amount != null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 7,
      children: [
        for (var i = 0; i < amounts.length; i++)
          SizedBox(
            width: 13,
            height: height,
            child: amounts[i] == null
                ? null
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: max == 0 ? 4 : (height * amounts[i]! / max).clamp(4, height),
                      decoration: BoxDecoration(
                        color: i == last ? AppColors.primary : AppColors.primaryTint,
                        borderRadius: AppRadius.chip,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}
