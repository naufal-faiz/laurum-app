import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

/// Google action of frame `LAURUM · Masuk`: white 48 dp button with the Google
/// brand SVG, plus the process/restoring status text and the safe error banner.
class SignInSection extends StatelessWidget {
  const SignInSection({
    required this.busy,
    required this.restoring,
    required this.onGoogle,
    this.error,
    super.key,
  });

  final bool busy, restoring;
  final String? error;
  final VoidCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    final textColor = busy ? AppColors.ink3 : AppColors.ink;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error != null) ...[
          BannerMessage(message: error!, variant: BannerMessageVariant.error),
          const SizedBox(height: AppSpacing.medium),
        ],
        if (busy) ...[
          Text(
            restoring ? 'Memulihkan data...' : 'Memproses permintaan...',
            style: AppTextStyles.caption.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.small),
        ],
        SizedBox(
          height: 48,
          child: Material(
            color: AppColors.surface,
            borderRadius: AppRadius.cta,
            child: InkWell(
              borderRadius: AppRadius.cta,
              onTap: busy ? null : onGoogle,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.cta,
                  border: Border.all(color: AppColors.borderStrong),
                  boxShadow: AppShadows.raised,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppSvg(AppSvgs.google, size: 20),
                      const SizedBox(width: AppSpacing.smallMedium),
                      Flexible(
                        child: Text(
                          'Lanjutkan dengan Google',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyStrong.copyWith(color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
