import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class CalloutAi extends StatelessWidget {
  const CalloutAi({
    required this.message,
    super.key,
    this.label = 'Periksa bagian ini',
    this.icon = AppIcons.location,
    this.compact = false,
  });
  final String message, label;
  final AppIcons icon;
  final bool compact;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    children: [
      AppIcon(icon, size: AppDimensions.iconSmall, color: AppColors.warningBorder),
      const SizedBox(width: AppMoleculeTokens.labelGap),
      Expanded(
        child: compact
            ? Text.rich(
                TextSpan(
                  text: message,
                  children: [
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AppBadge(label, variant: AppBadgeVariant.perhatian),
                    ),
                  ],
                ),
                style: AppTextStyles.caption.copyWith(color: AppColors.ink),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(message),
                  AppText(label, variant: AppTextVariant.label, color: AppColors.warningBorder),
                ],
              ),
      ),
    ],
  );
}
