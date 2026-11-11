import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/callout_ai.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ProposalAddressSection extends StatelessWidget {
  const ProposalAddressSection({
    required this.draft,
    required this.enabled,
    required this.uncertain,
    required this.onAddress,
    super.key,
  });
  final ProposalDraft draft;
  final bool enabled, uncertain;
  final ValueChanged<String> onAddress;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const SectionHeader(title: 'Alamat penjemputan', titleColor: AppColors.primaryInk),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: AppTextField(
          label: 'Alamat penjemputan',
          hint: 'Alamat penjemputan (opsional)',
          dense: true,
          leadingIcon: AppIcons.location,
          value: draft.address,
          enabled: enabled,
          selectAllOnFocus: true,
          maxLines: 3,
          onChanged: onAddress,
        ),
      ),
      if (uncertain)
        const CalloutAi(
          message: 'AI kurang yakin dengan nomor rumah/patokan detail.',
          compact: true,
        ),
    ],
  );
}
