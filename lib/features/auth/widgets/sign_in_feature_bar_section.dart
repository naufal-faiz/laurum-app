import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

/// Static feature strip of frame `LAURUM · Masuk` (display only, no action).
class SignInFeatureBarSection extends StatelessWidget {
  const SignInFeatureBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final style = AppAuthTextStyles.chip.copyWith(color: AppColors.authInk);
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: AppColors.authChipBg,
        borderRadius: AppRadius.authBar,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const AppIcon(AppIcons.queue, size: 13, color: AppColors.authPrimary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Antrean rapi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const AppIcon(AppIcons.receipt, size: 13, color: AppColors.authPrimary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Struk otomatis',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const AppIcon(AppIcons.reports, size: 13, color: AppColors.authPrimary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Laporan harian',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
