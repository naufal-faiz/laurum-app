import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

class CustomerDetailActionsSection extends StatelessWidget {
  const CustomerDetailActionsSection({
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    super.key,
    this.primaryIcon,
    this.secondaryIcon,
    this.primaryAsset,
    this.outlined = false,
  });
  final String primaryLabel, secondaryLabel;
  final VoidCallback? onPrimary, onSecondary;
  final AppIcons? primaryIcon, secondaryIcon;
  final String? primaryAsset;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      AppButton(
        primaryLabel,
        variant: outlined ? AppButtonVariant.actionOutline : AppButtonVariant.action,
        size: AppButtonSize.small,
        icon: primaryIcon,
        iconAsset: primaryAsset,
        onPressed: onPrimary,
      ),
      AppButton(
        secondaryLabel,
        variant: AppButtonVariant.actionOutline,
        size: AppButtonSize.small,
        icon: secondaryIcon,
        onPressed: onSecondary,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth < AppSpacing.touchTarget * 6 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.smallMedium,
              children: buttons,
            )
          : Row(
              spacing: AppSpacing.smallMedium,
              children: [for (final button in buttons) Expanded(child: button)],
            ),
    );
  }
}
