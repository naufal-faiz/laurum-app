import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

/// Kartu hero biru pemilik akun, mengikuti frame `LAURUM · Kelola Akun`.
class AccountIdentitySection extends StatelessWidget {
  const AccountIdentitySection({
    required this.name,
    required this.email,
    required this.googleLinked,
    required this.busy,
    required this.onEdit,
    super.key,
  });

  final String name, email;
  final bool googleLinked, busy;
  final VoidCallback onEdit;

  String get _initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word.characters.first.toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) => AppCard(
    style: AppCardStyle.primary,
    gradient: true,
    bubble: true,
    padding: const EdgeInsets.all(AppSpacing.mediumLarge),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.small,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.medium,
          children: [
            AppAvatar(initials: _initials, semanticLabel: 'Foto profil'),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxsmall,
                children: [
                  AppText(
                    name.trim().isEmpty ? 'Belum diisi' : name.trim(),
                    variant: AppTextVariant.section,
                    color: AppColors.onPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    email.isEmpty ? 'Email belum diisi' : email,
                    variant: AppTextVariant.caption,
                    color: AppColors.heroTagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppIconButton(
              label: 'Ubah profil',
              icon: AppIcons.edit,
              variant: AppIconButtonVariant.hero,
              onPressed: busy ? null : onEdit,
            ),
          ],
        ),
        AppBadge(
          googleLinked ? 'Tertaut dengan Google' : 'Tidak tertaut dengan Google',
          variant: AppBadgeVariant.inverse,
        ),
      ],
    ),
  );
}
