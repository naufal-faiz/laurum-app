import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_auth_text_styles.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

/// Google action of frame `LAURUM · Masuk`: white 48 dp button with G mark,
/// plus the process/restoring status text and the safe error banner.
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
    final textColor = busy ? AppColors.authLabel : AppColors.authInk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (error != null) ...[
          BannerMessage(message: error!, variant: BannerMessageVariant.error),
          const SizedBox(height: 12),
        ],
        if (busy) ...[
          Text(
            restoring ? 'Memulihkan data...' : 'Memproses permintaan...',
            style: AppAuthTextStyles.body.copyWith(color: AppColors.authInk),
          ),
          const SizedBox(height: 8),
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
                  border: Border.all(color: AppColors.authFieldBorder),
                  boxShadow: AppShadows.authGoogle,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.authLogo,
                          border: Border.all(color: AppColors.authGoogleBorder),
                        ),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: Text(
                              'G',
                              style: AppAuthTextStyles.googleMark.copyWith(
                                color: AppColors.authGoogleBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          'Lanjutkan dengan Google',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppAuthTextStyles.google.copyWith(color: textColor),
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
