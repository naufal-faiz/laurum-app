import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_address_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_customer_fields_section.dart';
import 'package:laurum/features/proposals/widgets/proposal_service_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class ProposalFieldsSection extends StatelessWidget {
  const ProposalFieldsSection({
    required this.review,
    required this.draft,
    required this.enabled,
    required this.onName,
    required this.onPhone,
    required this.onAddress,
    required this.onService,
    required this.onWeight,
    super.key,
  });
  final ProposalReview review;
  final ProposalDraft draft;
  final bool enabled;
  final ValueChanged<String> onName, onPhone, onAddress, onService, onWeight;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.large,
    children: [
      if (review.proposal.cancelRequested) const AppText('Permintaan pembatalan order'),
      if (!review.proposal.cancelRequested) ...[
        if (review.customer == null)
          ProposalCustomerFieldsSection(
            draft: draft,
            enabled: enabled,
            onName: onName,
            onPhone: onPhone,
          ),
        ProposalServiceSection(
          review: review,
          draft: draft,
          enabled: enabled,
          onService: onService,
          onWeight: onWeight,
        ),
        ProposalAddressSection(
          draft: draft,
          enabled: enabled,
          uncertain: review.proposal.uncertainAddress,
          onAddress: onAddress,
        ),
      ],
    ],
  );
}
