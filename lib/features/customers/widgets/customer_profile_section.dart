import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

class CustomerProfileSection extends StatelessWidget {
  const CustomerProfileSection({
    required this.summary,
    required this.onWhatsApp,
    required this.onEdit,
    super.key,
  });
  final CustomerDirectoryRow summary;
  final VoidCallback onWhatsApp, onEdit;
  @override
  Widget build(BuildContext context) {
    final customer = summary.customer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              Row(
                children: [
                  AppAvatar(initials: customerInitials(customer.name)),
                  const SizedBox(width: AppSpacing.cardGap),
                  Expanded(child: AppText(customer.name, variant: AppTextVariant.section)),
                ],
              ),
              InfoRow(label: 'Nomor WhatsApp', value: Formatters.telepon(customer.phone)),
              if (customer.address.isNotEmpty) InfoRow(label: 'Alamat', value: customer.address),
              if (customer.notes.isNotEmpty) InfoRow(label: 'Catatan', value: customer.notes),
              if (!customer.isActive)
                const BannerMessage(message: 'Pelanggan nonaktif. Riwayat tetap tersimpan.'),
              AppButton(
                'Buka WhatsApp',
                variant: AppButtonVariant.actionOutline,
                iconAsset: AppSvgs.whatsapp,
                onPressed: onWhatsApp,
              ),
              AppButton(
                'Edit profil',
                variant: AppButtonVariant.secondary,
                onPressed: customer.isActive ? onEdit : null,
              ),
            ],
          ),
        ),
        StatTile(
          label: 'Total belanja',
          value: Formatters.rupiah(summary.historyTotal),
          description: 'Akumulasi',
        ),
        StatTile(label: 'Frekuensi', value: '${summary.orderCount} order'),
        StatTile(label: 'Piutang aktif', value: Formatters.rupiah(summary.debt)),
      ],
    );
  }
}
