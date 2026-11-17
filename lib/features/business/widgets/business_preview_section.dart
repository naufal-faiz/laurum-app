import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('PRATINJAU STRUK', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.xsmall,
          children: [
            AppText(
              name.trim().isEmpty ? 'Nama usaha' : name.trim().toUpperCase(),
              variant: AppTextVariant.bodyStrong,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const AppDivider(),
            AppText(
              address.trim().isEmpty ? 'Alamat belum diisi' : address.trim(),
              variant: AppTextVariant.caption,
              color: AppColors.ink2,
              textAlign: TextAlign.center,
            ),
            AppText(
              phone.trim().isEmpty ? 'Nomor telepon belum diisi' : Formatters.telepon(phone),
              variant: AppTextVariant.caption,
              color: AppColors.ink2,
              textAlign: TextAlign.center,
            ),
            AppText(
              footer.trim().isEmpty ? 'Catatan kaki belum diisi' : footer.trim(),
              variant: AppTextVariant.caption,
              color: AppColors.ink3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ],
  );
}
