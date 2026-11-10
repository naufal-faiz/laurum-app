import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';

/// Thin bar split into proportional coloured segments (queue stage progress).
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({required this.segments, super.key});

  final List<({int value, Color color})> segments;

  @override
  Widget build(BuildContext context) {
    final filled = segments.where((segment) => segment.value > 0).toList();
    return ClipRRect(
      borderRadius: AppRadius.chip,
      child: SizedBox(
        height: 6,
        child: ColoredBox(
          color: AppColors.chipIdle,
          child: filled.isEmpty
              ? const SizedBox.shrink()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final segment in filled)
                      Expanded(
                        flex: segment.value,
                        child: ColoredBox(color: segment.color),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
