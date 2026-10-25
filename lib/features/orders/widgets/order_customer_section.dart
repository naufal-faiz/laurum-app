import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class OrderCustomerSection extends StatelessWidget {
  const OrderCustomerSection({required this.data, required this.onWhatsApp, super.key});
  final OrderDetailData data;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final customer = data.customer;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          Row(
            children: [
              AppAvatar(initials: customerInitials(customer.name), semanticLabel: customer.name),
              const SizedBox(width: AppSpacing.cardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(customer.name, variant: AppTextVariant.section),
                    AppText(
                      Formatters.telepon(customer.phone),
                      variant: AppTextVariant.caption,
                      color: AppColors.ink2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (customer.address.trim().isNotEmpty) AppText(customer.address, color: AppColors.ink2),
          if (customer.phone.trim().isNotEmpty)
            AppButton(
              'Buka WhatsApp',
              variant: AppButtonVariant.actionOutline,
              icon: AppIcons.chat,
              onPressed: onWhatsApp,
            ),
        ],
      ),
    );
  }
}
