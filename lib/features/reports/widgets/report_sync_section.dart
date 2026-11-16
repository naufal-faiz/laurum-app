import 'package:flutter/material.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class ReportSyncSection extends StatelessWidget {
  const ReportSyncSection({required this.status, super.key});
  final SyncServiceStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    SyncServiceStatus.offline => const BannerMessage(
      message: 'Mode offline. Data tersimpan di HP dan disinkronkan otomatis.',
    ),
    SyncServiceStatus.gagal => const BannerMessage(
      message: 'Sinkronisasi gagal. Data di HP tetap tersimpan.',
      variant: BannerMessageVariant.error,
    ),
    _ => const SizedBox.shrink(),
  };
}
