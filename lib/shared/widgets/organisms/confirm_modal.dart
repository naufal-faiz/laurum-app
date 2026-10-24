import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ConfirmModal extends StatelessWidget {
  const ConfirmModal({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
    this.cancelLabel = 'Kembali',
    this.destructive = false,
    this.icon = AppIcons.info,
  });

  final String title, message, confirmLabel, cancelLabel;
  final bool destructive;
  final AppIcons icon;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Kembali',
    bool destructive = false,
    AppIcons icon = AppIcons.info,
  }) => showDialog<bool>(
    context: context,
    barrierColor: AppColors.scrim,
    builder: (context) => ConfirmModal(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      destructive: destructive,
      icon: icon,
    ),
  );

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: AppColors.surface,
    elevation: 0,
    insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.modal),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 326),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: AppIcon(icon, color: AppColors.primary),
              ),
            ),
            AppText(title, variant: AppTextVariant.titleSub, textAlign: TextAlign.center),
            AppText(message, textAlign: TextAlign.center, color: AppColors.ink2),
            AppButton(
              confirmLabel,
              variant: destructive ? AppButtonVariant.destructiveFilled : AppButtonVariant.action,
              icon: AppIcons.check,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            AppButton(
              cancelLabel,
              variant: AppButtonVariant.actionOutline,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ),
    ),
  );
}
