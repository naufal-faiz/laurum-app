import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Raised centre action of the bottom navigation (58 ring, 52 circle, label).
class CreateAction extends StatelessWidget {
  const CreateAction({required this.label, super.key, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label baru',
    button: true,
    selected: false,
    excludeSemantics: true,
    onTap: onPressed,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: 58,
              child: Center(
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onPressed,
                    child: const SizedBox.square(
                      dimension: 52,
                      child: Center(
                        child: AppIcon(
                          AppIcons.add,
                          size: 20,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppText(label, variant: AppTextVariant.label, color: AppColors.primary),
        ],
      ),
    ),
  );
}
