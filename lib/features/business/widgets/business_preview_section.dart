import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Kartu hero biru berisi pratinjau struk, mengikuti frame `LAURUM · Info Usaha`.
class BusinessPreviewSection extends StatelessWidget {
  const BusinessPreviewSection({
    required this.name,
    required this.address,
    required this.phone,
    required this.footer,
    super.key,
  });
  final String name, address, phone, footer;

  @override
  Widget build(BuildContext context) => AppCard(
    style: AppCardStyle.primary,
    gradient: true,
    bubble: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xsmall,
      children: [
        const AppText(
          'PRATINJAU STRUK',
          variant: AppTextVariant.label,
          color: AppColors.heroTagline,
        ),
        AppText(
          name.trim().isEmpty ? 'Nama usaha' : name.trim().toUpperCase(),
          variant: AppTextVariant.bodyStrong,
          color: AppColors.onPrimary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppText(
          address.trim().isEmpty ? 'Alamat belum diisi' : address.trim(),
          variant: AppTextVariant.caption,
          color: AppColors.heroTagline,
        ),
        AppText(
          phone.trim().isEmpty ? 'Nomor telepon belum diisi' : Formatters.telepon(phone),
          variant: AppTextVariant.caption,
          color: AppColors.heroTagline,
        ),
        const AppDivider(),
        AppText(
          footer.trim().isEmpty ? 'Catatan kaki belum diisi' : footer.trim(),
          variant: AppTextVariant.caption,
          color: AppColors.onPrimary,
        ),
      ],
    ),
  );
}
