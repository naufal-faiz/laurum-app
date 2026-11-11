import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/proposal_review.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class ProposalCustomerFieldsSection extends StatelessWidget {
  const ProposalCustomerFieldsSection({
    required this.draft,
    required this.enabled,
    required this.onName,
    required this.onPhone,
    super.key,
  });
  final ProposalDraft draft;
  final bool enabled;
  final ValueChanged<String> onName, onPhone;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
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
    ),
  );
}
