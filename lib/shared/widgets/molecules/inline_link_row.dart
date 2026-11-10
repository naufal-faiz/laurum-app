import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';

/// Centered question followed by a link: "Belum punya akun? Daftar".
class InlineLinkRow extends StatelessWidget {
  const InlineLinkRow({
    required this.question,
    required this.action,
    super.key,
    this.onTap,
  });

  final String question, action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: AppText(
          question,
          variant: AppTextVariant.caption,
          color: AppColors.ink3,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: AppMoleculeTokens.smallGap),
      Flexible(child: InlineLink(action, onTap: onTap)),
    ],
  );
}
