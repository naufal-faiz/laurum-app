import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

/// Pintasan ke layar Printer & Struk dari Info usaha.
class BusinessPrinterSection extends StatelessWidget {
  const BusinessPrinterSection({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('STRUK & PRINTER', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        padding: EdgeInsets.zero,
        child: MenuRow(
          label: 'Printer dan struk',
          subtitle: 'Atur catatan tambahan & ukuran kertas',
          icon: AppIcons.printer,
          compact: true,
          onTap: onTap,
        ),
      ),
    ],
  );
}
