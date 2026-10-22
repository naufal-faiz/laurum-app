import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_control_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.initials, this.semanticLabel});
  final String? initials;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: true,
    child: ExcludeSemantics(
      child: Container(
        width: AppControlTokens.avatarSize,
        height: AppControlTokens.avatarSize,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColors.primaryTint, borderRadius: AppRadius.chip),
        child: initials == null || initials!.trim().isEmpty
            ? const AppIcon(AppIcons.avatar, color: AppColors.primary)
            : AppText(
                initials!,
                variant: AppTextVariant.section,
                color: AppColors.primary,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
      ),
    ),
  );
}
