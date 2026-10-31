import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/whatsapp_link.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

class WhatsappLinkSection extends StatelessWidget {
  const WhatsappLinkSection({
    required this.status,
    required this.onCheck,
    required this.onRefresh,
    required this.onDone,
    super.key,
  });
  final WhatsappLinkStatus status;
  final VoidCallback onCheck, onRefresh, onDone;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const BannerMessage(
        message: 'Gunakan nomor WhatsApp usaha, bukan nomor pribadi.',
        variant: BannerMessageVariant.warning,
      ),
      const AppText('1. Buka WhatsApp di HP usaha.'),
      const AppText('2. Pilih Perangkat tertaut.'),
      const AppText('3. Ketuk Tautkan perangkat lalu pindai kode.'),
      AppCard(
        child: Column(
          spacing: AppSpacing.cardGap,
          children: [
            SizedBox(
              height: AppSpacing.appBarHeight * 2,
              child: Center(
                child: AppIcon(
                  status == WhatsappLinkStatus.connected ? AppIcons.check : AppIcons.qrCode,
                  size: AppSpacing.appBarHeight,
                ),
              ),
            ),
            AppText(
              status == WhatsappLinkStatus.connected
                  ? 'WhatsApp usaha terhubung.'
                  : 'Pratinjau kode QR',
            ),
            AppText(switch (status) {
              WhatsappLinkStatus.waiting => 'Menunggu pindai',
              WhatsappLinkStatus.connected => 'Terhubung',
              WhatsappLinkStatus.expired => 'Kode kedaluwarsa',
            }, variant: AppTextVariant.section),
          ],
        ),
      ),
      AppButton(
        switch (status) {
          WhatsappLinkStatus.waiting => 'Periksa koneksi',
          WhatsappLinkStatus.connected => 'Kembali ke pengaturan',
          WhatsappLinkStatus.expired => 'Muat ulang kode',
        },
        onPressed: switch (status) {
          WhatsappLinkStatus.waiting => onCheck,
          WhatsappLinkStatus.connected => onDone,
          WhatsappLinkStatus.expired => onRefresh,
        },
      ),
      const NoticeAi(),
    ],
  );
}
