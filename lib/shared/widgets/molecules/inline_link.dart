import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Inline text link. Primary when tappable, muted when `onTap` is null.
class InlineLink extends StatelessWidget {
  const InlineLink(this.label, {super.key, this.onTap, this.semanticsLabel});

  final String label;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.ink3,
    ),
    child: AppText(
      label,
      variant: AppTextVariant.label,
      color: onTap == null ? AppColors.ink3 : AppColors.primary,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      semanticsLabel: semanticsLabel,
    ),
  );
}
