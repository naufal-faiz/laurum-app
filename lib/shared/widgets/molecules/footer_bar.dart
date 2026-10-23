import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({required this.child, super.key, this.summary});
  final Widget child;
  final Widget? summary;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: AppColors.surface, boxShadow: AppShadows.footer),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (summary != null) ...[summary!, const SizedBox(height: AppSpacing.cardGap)],
            child,
          ],
        ),
      ),
    ),
  );
}
