import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/pages/proposal_service_picker_flow.dart';
import 'package:laurum/features/proposals/pages/proposal_weight_flow.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/features/proposals/widgets/proposal_service_card_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ProposalServiceSection extends StatelessWidget {
  const ProposalServiceSection({
    required this.review,
    required this.draft,
    required this.enabled,
    required this.onService,
    required this.onWeight,
    super.key,
  });
  final ProposalReview review;
  final ProposalDraft draft;
  final bool enabled;
  final ValueChanged<String> onService, onWeight;
  @override
  Widget build(BuildContext context) {
    final service = review.services.where((s) => s.id == draft.serviceId).firstOrNull;
    final kilo = service?.kind == ServiceKind.kiloan;
    final total = service == null || (kilo && draft.weightMilli == 0)
        ? null
        : Formatters.rupiah(
            lineTotal(qtyMilli: kilo ? draft.weightMilli : 1000, unitPrice: service.price),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        const SectionHeader(
          title: 'Layanan yang diusulkan AI',
          titleColor: AppColors.primaryInk,
          subtitle: 'Ketuk Ubah jika AI salah tafsir',
        ),
        ProposalServiceCardSection(
          serviceName: service?.name ?? 'Pilih layanan',
          weight: !kilo || draft.weightMilli == 0 ? null : Formatters.berat(draft.weightMilli),
          total: total,
          kilo: kilo,
          enabled: enabled,
          onChangeService: enabled
              ? () => showProposalServicePicker(
                  context,
                  services: review.services,
                  selectedId: draft.serviceId,
                  onService: onService,
                )
              : null,
          onChangeWeight: enabled
              ? () => showProposalWeightSheet(
                  context,
                  id: review.proposal.id,
                  value: draft.weight,
                  onChanged: onWeight,
                )
              : null,
        ),
        if (kilo && draft.weightError != null)
          AppText(draft.weightError!, variant: AppTextVariant.caption, color: AppColors.errorInk),
      ],
    );
  }
}
