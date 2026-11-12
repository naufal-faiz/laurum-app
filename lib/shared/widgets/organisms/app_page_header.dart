import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.action,
    this.status,
  });
  final String title, subtitle;
  final Widget? action, status;
  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final detail = AppText(subtitle, variant: AppTextVariant.caption, color: AppColors.ink3);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.medium * scale,
        AppSpacing.screenPadding,
        AppSpacing.small,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.small,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'LAURUM',
                      variant: AppTextVariant.label,
                      color: AppColors.primary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      title,
                      variant: AppTextVariant.titleRoot,
                      color: AppColors.primaryInk,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ?action,
            ],
          ),
          if (subtitle.isNotEmpty || status != null)
            LayoutBuilder(
              builder: (context, constraints) => scale > 1.3 || constraints.maxWidth < 320
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.small,
                      children: [if (subtitle.isNotEmpty) detail, ?status],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.small,
                      children: [
                        Expanded(child: detail),
                        ?status,
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}
