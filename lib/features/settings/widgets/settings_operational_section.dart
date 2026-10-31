import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SettingsOperationalSection extends StatelessWidget {
  const SettingsOperationalSection({required this.connected, required this.onNavigate, super.key});
  final bool connected;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const SectionHeader(title: 'OPERASIONAL'),
      AppCard(
        child: Column(
          children: [
            MenuRow(
              label: 'Layanan dan tarif',
              subtitle: 'Cuci setrika, kiloan, satuan • Ubah tarif',
              icon: AppIcons.service,
              onTap: () => onNavigate('/lainnya/layanan'),
            ),
            const AppDivider(),
            MenuRow(
              label: 'Pengeluaran',
              subtitle: 'Bulan ini',
              icon: AppIcons.wallet,
              onTap: () => onNavigate('/lainnya/pengeluaran'),
            ),
            const AppDivider(),
            MenuRow(
              label: 'Printer dan struk',
              subtitle: 'Thermal 58mm/80mm • Bluetooth',
              icon: AppIcons.printer,
              onTap: () => onNavigate('/lainnya/printer'),
            ),
            const AppDivider(),
            MenuRow(
              label: 'Otomatisasi AI',
              subtitle: connected
                  ? 'Integrasi WhatsApp AI • Terhubung'
                  : 'Integrasi WhatsApp AI • Terputus',
              icon: AppIcons.chat,
              onTap: () => onNavigate('/lainnya/ai'),
            ),
          ],
        ),
      ),
      const NoticeAi(),
    ],
  );
}
