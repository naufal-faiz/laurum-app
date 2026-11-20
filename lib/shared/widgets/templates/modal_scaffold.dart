import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ModalScaffold extends StatelessWidget {
  const ModalScaffold({
    required this.title,
    required this.child,
    required this.footer,
    required this.onClose,
    this.subtitle,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget child, footer;
  final VoidCallback onClose;

  static Future<T?> show<T>({required BuildContext context, required Widget child}) =>
      showDialog<T>(
        context: context,
        barrierColor: AppColors.scrim,
        builder: (context) => child,
      );

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: AppColors.surface,
    elevation: 0,
    insetPadding: const EdgeInsets.all(AppSpacing.xlarge),
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.modal),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: AppSpacing.touchTarget * 8,
        maxHeight: MediaQuery.sizeOf(context).height * .85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.small,
              AppSpacing.small,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(title, variant: AppTextVariant.titleSub),
                      if (subtitle != null)
                        AppText(subtitle!, variant: AppTextVariant.caption, color: AppColors.ink3),
                    ],
                  ),
                ),
                AppIconButton(icon: AppIcons.close, label: 'Tutup', onPressed: onClose),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: child,
            ),
          ),
          Padding(padding: const EdgeInsets.all(AppSpacing.large), child: footer),
        ],
      ),
    ),
  );
}
