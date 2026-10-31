import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/callout_ai.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class ProposalFieldsSection extends StatelessWidget {
  const ProposalFieldsSection({
    required this.review,
    required this.draft,
    required this.enabled,
    required this.onName,
    required this.onPhone,
    required this.onAddress,
    required this.onService,
    super.key,
  });
  final ProposalReview review;
  final ProposalDraft draft;
  final bool enabled;
  final ValueChanged<String> onName, onPhone, onAddress, onService;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(
        title: 'Hasil bacaan AI',
        subtitle: 'Periksa dan sesuaikan sebelum menyetujui',
      ),
      if (review.proposal.cancelRequested) const AppText('Permintaan pembatalan order'),
      if (!review.proposal.cancelRequested) ...[
        if (review.customer == null) ...[
          LabeledField(
            label: 'Nama pelanggan',
            child: AppTextField(
              label: 'Nama pelanggan',
              value: draft.name,
              selectAllOnFocus: true,
              enabled: enabled,
              onChanged: onName,
              errorText: draft.name.trim().isEmpty ? 'Nama pelanggan wajib diisi.' : null,
            ),
          ),
          LabeledField(
            label: 'Nomor WhatsApp',
            child: AppTextField(
              label: 'Nomor WhatsApp',
              value: draft.phone,
              selectAllOnFocus: true,
              keyboardType: TextInputType.phone,
              enabled: enabled,
              onChanged: onPhone,
              errorText: draft.phoneValid ? null : 'Nomor WhatsApp tidak valid.',
            ),
          ),
          const AppText('Pelanggan akan dibuat saat Anda menyetujui order.'),
        ],
        const AppText('Layanan', variant: AppTextVariant.label),
        ChipBar(
          labels: review.services.map((s) => s.name).toList(),
          selectedIndex: review.services.any((s) => s.id == draft.serviceId)
              ? review.services.indexWhere((s) => s.id == draft.serviceId)
              : null,
          onSelected: enabled ? (i) => onService(review.services[i].id) : null,
        ),
        for (final service in review.services.where((s) => s.id == draft.serviceId))
          AppText(
            '${Formatters.rupiah(service.price)} / ${service.kind == ServiceKind.kiloan ? 'kg' : 'pcs'}',
          ),
        if (review.services.any((s) => s.id == draft.serviceId && s.kind == ServiceKind.kiloan))
          const AppText('Berat belum diisi. Lengkapi setelah disetujui lewat Edit order.'),
        LabeledField(
          label: 'Alamat penjemputan (opsional)',
          child: AppTextField(
            label: 'Alamat penjemputan',
            value: draft.address,
            enabled: enabled,
            selectAllOnFocus: true,
            maxLines: 3,
            onChanged: onAddress,
          ),
        ),
        if (review.proposal.uncertainAddress)
          const CalloutAi(message: 'AI kurang yakin dengan nomor rumah/patokan detail.'),
      ],
    ],
  );
}
