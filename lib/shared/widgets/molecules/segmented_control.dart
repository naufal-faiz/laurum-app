import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    required this.labels,
    required this.selectedIndex,
    super.key,
    this.onSelected,
  }) : assert(selectedIndex >= 0);

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    assert(selectedIndex < labels.length);
    return Container(
      height: AppControlTokens.switchHeight + AppControlTokens.switchInset * 2,
      padding: AppControlTokens.switchPadding,
      decoration: const BoxDecoration(
        color: AppColors.chipIdle,
        borderRadius: AppRadius.small,
      ),
      child: Row(
        spacing: AppControlTokens.switchInset,
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                selected: i == selectedIndex,
                child: TextButton(
                  onPressed: onSelected == null ? null : () => onSelected!(i),
                  style: TextButton.styleFrom(
                    backgroundColor: i == selectedIndex ? AppColors.primary : AppColors.chipIdle,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.small,
                    ),
                  ),
                  child: AppText(
                    labels[i],
                    variant: AppTextVariant.label,
                    color: i == selectedIndex ? AppColors.onPrimary : AppColors.ink2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
