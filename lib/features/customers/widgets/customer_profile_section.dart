import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_detail_actions_section.dart';
import 'package:laurum/features/customers/widgets/customer_statistics_section.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

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
          style: AppCardStyle.primary,
          bubble: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.cardGap,
                children: [
                  MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1,
                    child: AppAvatar(initials: customerInitials(customer.name)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxsmall,
                      children: [
                        AppText(
                          customer.name,
                          variant: AppTextVariant.section,
                          color: AppColors.onPrimary,
                        ),
                        AppText(
                          Formatters.telepon(customer.phone),
                          variant: AppTextVariant.caption,
                          color: AppColors.onPrimary,
                        ),
                        if (customer.address.isNotEmpty)
                          AppText(
                            customer.address,
                            variant: AppTextVariant.caption,
                            color: AppColors.onPrimary,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (customer.notes.isNotEmpty)
                AppText(
                  customer.notes,
                  variant: AppTextVariant.caption,
                  color: AppColors.onPrimary,
                  semanticsLabel: 'Catatan: ${customer.notes}',
                ),
              if (!customer.isActive)
                const BannerMessage(message: 'Pelanggan nonaktif. Riwayat tetap tersimpan.'),
              CustomerDetailActionsSection(
                primaryLabel: 'Buka WhatsApp',
                secondaryLabel: 'Edit profil',
                primaryAsset: AppSvgs.whatsapp,
                secondaryIcon: AppIcons.edit,
                outlined: true,
                onPrimary: onWhatsApp,
                onSecondary: customer.isActive ? onEdit : null,
              ),
            ],
          ),
        ),
        CustomerStatisticsSection(summary: summary),
      ],
    );
  }
}
