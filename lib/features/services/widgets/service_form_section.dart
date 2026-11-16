import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_duration_section.dart';
import 'package:laurum/features/services/widgets/service_information_section.dart';
import 'package:laurum/features/services/widgets/service_preview_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class ServiceFormSection extends StatelessWidget {
  const ServiceFormSection({
    required this.state,
    required this.onName,
    required this.onKind,
    required this.onPrice,
    required this.onDuration,
    required this.onActive,
    super.key,
  });
  final ServiceEditState state;
  final ValueChanged<String> onName, onPrice;
  final ValueChanged<int> onKind, onDuration;
  final ValueChanged<bool> onActive;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.mediumLarge,
    children: [
      ServicePreviewSection(state: state),
      if (state.isEdit)
        const AppText(
          'Perubahan harga tidak memengaruhi nota yang sudah tercetak.',
          variant: AppTextVariant.caption,
        ),
      const AppText('Informasi layanan', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.mediumLarge),
        child: ServiceInformationSection(
          state: state,
          onName: onName,
          onKind: onKind,
          onPrice: onPrice,
        ),
      ),
      const AppText('Durasi & status', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.mediumLarge),
        child: ServiceDurationSection(state: state, onDuration: onDuration, onActive: onActive),
      ),
      const BannerMessage(message: 'Layanan aktif langsung tersedia di kasir setelah disimpan.'),
      if (state.notice != null)
        BannerMessage(message: state.notice!, variant: BannerMessageVariant.error),
    ],
  );
}
