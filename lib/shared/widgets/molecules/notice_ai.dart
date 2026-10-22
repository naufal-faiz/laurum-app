import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/core/theme/app_radius.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class NoticeAi extends StatelessWidget {
  const NoticeAi({super.key});
  static const message =
      'AI hanya membaca pesan WhatsApp. AI tidak pernah mengirim pesan atau mengubah order tanpa persetujuan Anda.';
  @override
  Widget build(BuildContext context) => Container(
    padding: AppMoleculeTokens.noticePadding,
    decoration: const BoxDecoration(color: AppColors.primaryTint, borderRadius: AppRadius.numpad),
    child: const AppText(message, color: AppColors.ink2),
  );
}
