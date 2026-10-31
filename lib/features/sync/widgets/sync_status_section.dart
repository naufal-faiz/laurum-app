import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/sync/state/sync_view.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SyncStatusSection extends StatelessWidget {
  const SyncStatusSection({
    required this.data,
    required this.busy,
    required this.failed,
    required this.conflictExample,
    required this.onSync,
    super.key,
  });
  final SyncView data;
  final bool busy, failed;
  final String conflictExample;
  final VoidCallback onSync;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (data.status == SyncServiceStatus.offline)
        const BannerMessage(
          message: 'Mode offline. Data tersimpan di HP dan disinkronkan otomatis.',
        ),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            AppText(data.label, variant: AppTextVariant.section),
            AppText('${data.pending} perubahan tertunda'),
            AppText(
              data.lastSyncedAt == null
                  ? 'Belum pernah sinkron'
                  : 'Sinkron terakhir: ${Formatters.tanggal(data.lastSyncedAt!)} ${Formatters.jam(data.lastSyncedAt!)}',
            ),
            AppButton('Sinkron sekarang', onPressed: busy ? null : onSync),
          ],
        ),
      ),
      if (failed)
        const BannerMessage(
          message: 'Sinkronisasi gagal. Data di HP tetap tersimpan. Coba lagi.',
          variant: BannerMessageVariant.error,
        ),
      if (conflictExample.isNotEmpty) ...[
        const SectionHeader(title: 'Konflik data'),
        AppCard(child: AppText(conflictExample)),
      ],
    ],
  );
}
