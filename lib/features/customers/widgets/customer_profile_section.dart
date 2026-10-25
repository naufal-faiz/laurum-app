import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_edit_sheet.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/info_row.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';

class CustomerProfileSection extends ConsumerWidget {
  const CustomerProfileSection({required this.summary, super.key});
  final CustomerDirectoryRow summary;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                icon: AppIcons.chat,
                onPressed: customer.phone.isEmpty
                    ? null
                    : () => ref
                          .read(externalLauncherProvider)
                          .launchWhatsApp(phone: customer.phone, message: ''),
              ),
              AppButton(
                'Edit profil',
                variant: AppButtonVariant.secondary,
                onPressed: customer.isActive
                    ? () => CustomerEditSheet.show(context, ref, customer)
                    : null,
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
