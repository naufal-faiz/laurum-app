import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

enum BannerMessageVariant { info, warning, error }

class BannerMessage extends StatelessWidget {
  const BannerMessage({required this.message, super.key, this.variant = BannerMessageVariant.info});
  final String message;
  final BannerMessageVariant variant;
  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = switch (variant) {
      BannerMessageVariant.info => (AppColors.primaryTint, AppColors.primary, AppIcons.info),
      BannerMessageVariant.warning => (AppColors.warningTint, AppColors.warningInk, AppIcons.alert),
      BannerMessageVariant.error => (AppColors.errorTint, AppColors.errorInk, AppIcons.alert),
    };
    return Container(
      padding: AppMoleculeTokens.noticePadding,
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.numpad),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(icon, size: AppDimensions.iconAction, color: foreground),
          const SizedBox(width: AppMoleculeTokens.gap),
          Expanded(
            child: AppText(
              message,
              color: variant == BannerMessageVariant.info ? AppColors.ink2 : foreground,
            ),
          ),
        ],
      ),
    );
  }
}
