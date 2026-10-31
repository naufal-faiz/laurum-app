import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class AiConnectionSection extends StatelessWidget {
  const AiConnectionSection({
    required this.connected,
    required this.phone,
    required this.onConnect,
    required this.onDisconnect,
    required this.onCheck,
    super.key,
  });
  final bool connected;
  final String phone;
  final VoidCallback onConnect, onDisconnect, onCheck;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'WhatsApp'),
      if (!connected)
        const BannerMessage(
          message: 'WhatsApp terputus. Pembacaan pesan dijeda.',
          variant: BannerMessageVariant.warning,
        ),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.cardGap,
          children: [
            AppText(connected ? 'Terhubung' : 'Terputus', variant: AppTextVariant.section),
            AppText(Formatters.telepon(phone)),
            const AppText('Nomor usaha'),
            AppButton(
              connected ? 'Uji koneksi' : 'Hubungkan WhatsApp',
              variant: AppButtonVariant.actionOutline,
              onPressed: connected ? onCheck : onConnect,
            ),
            if (connected)
              AppButton(
                'Putuskan koneksi',
                icon: AppIcons.close,
                variant: AppButtonVariant.destructiveOutline,
                onPressed: onDisconnect,
              ),
          ],
        ),
      ),
    ],
  );
}
