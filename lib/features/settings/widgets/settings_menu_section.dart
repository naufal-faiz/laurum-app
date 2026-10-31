import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/settings/widgets/settings_account_section.dart';
import 'package:laurum/features/settings/widgets/settings_operational_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class SettingsMenuSection extends StatelessWidget {
  const SettingsMenuSection({
    required this.address,
    required this.connected,
    required this.useOrderStatus,
    required this.onOrderStatusChanged,
    required this.onNavigate,
    required this.onLogout,
    this.error,
    super.key,
  });
  final String address;
  final bool connected, useOrderStatus;
  final String? error;
  final ValueChanged<bool>? onOrderStatusChanged;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        SettingsOperationalSection(connected: connected, onNavigate: onNavigate),
        const SectionHeader(title: 'PENGATURAN'),
        if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
        AppCard(
          child: Column(
            children: [
              MenuRow(
                label: 'Info usaha & alamat',
                subtitle: address,
                icon: AppIcons.location,
                onTap: () => onNavigate('/lainnya/info-usaha'),
              ),
              const AppDivider(),
              ToggleRow(
                label: 'Pakai status order',
                value: useOrderStatus,
                description: "Matikan bila usaha tidak melacak tahap cucian. Order baru langsung 'Sedang dikerjakan'.",
                onChanged: onOrderStatusChanged,
              ),
              const AppDivider(),
              MenuRow(
                label: 'Sinkronisasi',
                subtitle: 'Status penyimpanan dan akun',
                icon: AppIcons.refresh,
                onTap: () => onNavigate('/lainnya/sinkronisasi'),
              ),
            ],
          ),
        ),
        SettingsAccountSection(onLogout: onLogout),
      ],
    ),
  );
}
