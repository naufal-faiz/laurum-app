import 'package:flutter/material.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class CustomerContactCard extends StatelessWidget {
  const CustomerContactCard({
    required this.name,
    required this.phone,
    super.key,
    this.initials,
    this.address,
    this.badge,
    this.showContact = true,
    this.onContact,
    this.contactLabel = 'Buka WhatsApp',
  });
  final String name, phone, contactLabel;
  final String? initials, address;
  final Widget? badge;
  final bool showContact;
  final VoidCallback? onContact;
  @override
  Widget build(BuildContext context) {
    final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    final last = words.length > 1 ? words.last[0] : '';
    final letters = words.isEmpty ? '' : '${words.first[0]}$last'.toUpperCase();
    final hasAddress = address?.trim().isNotEmpty ?? false;
    final phoneText = AppText(
      Formatters.telepon(phone),
      variant: AppTextVariant.caption,
      color: AppColors.ink3,
    );
    final addressText = AppText(
      address ?? '',
      variant: AppTextVariant.caption,
      color: AppColors.ink3,
    );
    final contact = AppButton(
      contactLabel,
      variant: AppButtonVariant.actionOutline,
      size: AppButtonSize.small,
      iconAsset: AppSvgs.whatsapp,
      onPressed: onContact,
    );
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow =
              constraints.maxWidth < AppSpacing.touchTarget * 6 ||
              MediaQuery.textScalerOf(context).scale(1) > 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.small,
            children: [
              Row(
                spacing: AppSpacing.small,
                children: [
                  AppAvatar(initials: initials ?? letters, semanticLabel: name),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxsmall,
                      children: [
                        AppText(name, variant: AppTextVariant.bodyStrong),
                        Row(
                          spacing: AppSpacing.xxsmall,
                          children: [
                            const AppIcon(AppIcons.phone, size: AppDimensions.iconTiny),
                            Expanded(child: phoneText),
                          ],
                        ),
                        ?badge,
                      ],
                    ),
                  ),
                  if (showContact && !hasAddress && !narrow) contact,
                ],
              ),
              if (hasAddress)
                Row(
                  spacing: AppSpacing.small,
                  children: [
                    const AppIcon(
                      AppIcons.location,
                      size: AppDimensions.iconSmall,
                      color: AppColors.primary,
                    ),
                    Expanded(child: addressText),
                    if (showContact && !narrow) contact,
                  ],
                ),
              if (showContact && narrow) Align(alignment: Alignment.centerRight, child: contact),
            ],
          );
        },
      ),
    );
  }
}
