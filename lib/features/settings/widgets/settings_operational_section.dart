import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

class SettingsOperationalSection extends StatelessWidget {
  const SettingsOperationalSection({required this.connected, required this.onNavigate, super.key});
  final bool connected;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('OPERASIONAL', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.xxsmall / 2),
        child: Column(
          children: [
            MenuRow(
              compact: true,
              label: 'Layanan dan tarif',
              subtitle: 'Cuci setrika, kiloan, satuan • Ubah tarif',
              icon: AppIcons.service,
              onTap: () => onNavigate('/lainnya/layanan'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppDivider(),
            ),
            MenuRow(
              compact: true,
              label: 'Pengeluaran',
              subtitle: 'Bulan ini',
              icon: AppIcons.wallet,
              onTap: () => onNavigate('/lainnya/pengeluaran'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppDivider(),
            ),
            MenuRow(
              compact: true,
              label: 'Laporan',
              subtitle: 'Pendapatan, pengeluaran & performa',
              icon: AppIcons.reports,
              onTap: () => onNavigate('/laporan'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppDivider(),
            ),
            MenuRow(
              compact: true,
              label: 'Printer dan struk',
              subtitle: 'Thermal 58mm/80mm • Bluetooth',
              icon: AppIcons.printer,
              onTap: () => onNavigate('/lainnya/printer'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
              child: AppDivider(),
            ),
            MenuRow(
              compact: true,
              label: 'Otomatisasi AI',
              subtitle: connected
                  ? 'Integrasi WhatsApp AI • Terhubung'
                  : 'Integrasi WhatsApp AI • Terputus',
              icon: AppIcons.chat,
              iconAsset: AppSvgs.whatsapp,
              iconTileColor: AppColors.successTint,
              onTap: () => onNavigate('/lainnya/ai'),
            ),
          ],
        ),
      ),
      const NoticeAi(compact: true),
    ],
  );
}
