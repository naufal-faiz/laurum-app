import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/settings/pages/settings_account_page.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class SettingsMenuPage extends StatelessWidget {
  const SettingsMenuPage({
    required this.address,
    required this.connected,
    required this.onLogout,
    super.key,
  });

  final String address;
  final bool connected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
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
                onTap: () => context.push('/lainnya/layanan'),
              ),
              const AppDivider(),
              MenuRow(
                label: 'Pengeluaran',
                subtitle: 'Bulan ini',
                icon: AppIcons.wallet,
                onTap: () => context.push('/lainnya/pengeluaran'),
              ),
              const AppDivider(),
              MenuRow(
                label: 'Printer dan struk',
                subtitle: 'Thermal 58mm/80mm • Bluetooth',
                icon: AppIcons.printer,
                onTap: () => context.push('/lainnya/printer'),
              ),
              const AppDivider(),
              MenuRow(
                label: 'Otomatisasi AI',
                subtitle: connected
                    ? 'Integrasi WhatsApp AI • Terhubung'
                    : 'Integrasi WhatsApp AI • Terputus',
                icon: AppIcons.chat,
                onTap: () => context.push('/lainnya/ai'),
              ),
            ],
          ),
        ),
        const NoticeAi(),
        const SectionHeader(title: 'PENGATURAN'),
        AppCard(
          child: Column(
            children: [
              MenuRow(
                label: 'Info usaha & alamat',
                subtitle: address,
                icon: AppIcons.location,
                onTap: () => context.push('/lainnya/info-usaha'),
              ),
              const AppDivider(),
              MenuRow(
                label: 'Sinkronisasi',
                subtitle: 'Status penyimpanan dan akun',
                icon: AppIcons.refresh,
                onTap: () => context.push('/lainnya/sinkronisasi'),
              ),
            ],
          ),
        ),
        SettingsAccountPage(onLogout: onLogout),
      ],
    ),
  );
}
