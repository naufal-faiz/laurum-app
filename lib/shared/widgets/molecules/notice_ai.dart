import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class NoticeAi extends StatelessWidget {
  const NoticeAi({super.key, this.compact = false});
  final bool compact;
  static const message =
      'AI hanya membaca pesan WhatsApp. AI tidak pernah mengirim pesan atau mengubah order tanpa persetujuan Anda.';
  @override
  Widget build(BuildContext context) => Container(
    padding: compact ? const EdgeInsets.all(AppSpacing.small) : AppMoleculeTokens.noticePadding,
    decoration: const BoxDecoration(color: AppColors.successTint, borderRadius: AppRadius.numpad),
    child: AppText(
      message,
      color: AppColors.success,
      variant: compact ? AppTextVariant.caption : AppTextVariant.body,
    ),
  );
}
