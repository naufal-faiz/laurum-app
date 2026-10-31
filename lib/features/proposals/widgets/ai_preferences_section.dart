import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/ai_settings.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class AiPreferencesSection extends StatelessWidget {
  const AiPreferencesSection({
    required this.value,
    required this.onRead,
    required this.onGroups,
    required this.onCancellation,
    super.key,
  });
  final AiPreferences value;
  final ValueChanged<bool> onRead, onGroups, onCancellation;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'Pembacaan pesan'),
      AppCard(
        child: Column(
          children: [
            ToggleRow(
              label: 'Baca pesan WhatsApp',
              value: value.readMessages,
              onChanged: onRead,
              description:
                  'Buat usulan di Perlu dicek pada Antrean. Matikan untuk menjeda pembacaan pesan.',
            ),
            ToggleRow(
              label: 'Abaikan pesan grup',
              value: value.ignoreGroups,
              onChanged: onGroups,
              description: 'Hanya pesan pribadi yang diproses. Pesan grup diabaikan.',
            ),
            ToggleRow(
              label: 'Deteksi permintaan batal',
              value: value.detectCancellation,
              onChanged: onCancellation,
              description: 'Pembatalan order tetap memerlukan persetujuan Anda.',
            ),
          ],
        ),
      ),
      const SectionHeader(title: 'Penyimpanan pesan'),
      const AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.cardGap,
          children: [
            AppText('Privasi pelanggan', variant: AppTextVariant.label),
            AppText('Hapus pesan setelah 30 hari (bawaan)'),
            AppText('Hanya pesan terkait pesanan yang disimpan. Pesan lain langsung dibuang.'),
          ],
        ),
      ),
    ],
  );
}
