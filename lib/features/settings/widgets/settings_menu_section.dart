import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/settings/widgets/settings_account_section.dart';
import 'package:laurum/features/settings/widgets/settings_operational_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
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
    this.email = '',
    this.accountBusy = false,
    super.key,
  });
  final String address;
  final bool connected, useOrderStatus;
  final String? error;
  final ValueChanged<bool>? onOrderStatusChanged;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;
  final String email;
  final bool accountBusy;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xlarge,
      vertical: AppSpacing.smallMedium,
    ).add(const EdgeInsets.only(bottom: AppDimensions.navCreateSize / 2)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.small,
      children: [
        SettingsOperationalSection(connected: connected, onNavigate: onNavigate),
        const AppText('PENGATURAN', variant: AppTextVariant.caption, color: AppColors.ink3),
        if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              MenuRow(
                compact: true,
                label: 'Info usaha & alamat',
                subtitle: address,
                icon: AppIcons.location,
                onTap: () => onNavigate('/lainnya/info-usaha'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
                child: AppDivider(),
              ),
              ToggleRow(
                compact: true,
                icon: AppIcons.queue,
                label: 'Pakai status order',
                value: useOrderStatus,
                description: "Matikan bila usaha tidak melacak tahap cucian. Order baru langsung 'Sedang dikerjakan'.",
                onChanged: onOrderStatusChanged,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.mediumLarge),
                child: AppDivider(),
              ),
              MenuRow(
                compact: true,
                label: 'Sinkronisasi',
                subtitle: 'Status penyimpanan dan akun',
                icon: AppIcons.refresh,
                onTap: () => onNavigate('/lainnya/sinkronisasi'),
              ),
            ],
          ),
        ),
        SettingsAccountSection(
          onLogout: onLogout,
          email: email,
          onManage: () => onNavigate('/lainnya/akun'),
          busy: accountBusy,
        ),
      ],
    ),
  );
}
