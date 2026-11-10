import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

class AntreanHeaderSection extends StatelessWidget {
  const AntreanHeaderSection({required this.searchOpen, required this.onSearch, super.key});
  final bool searchOpen;
  final VoidCallback onSearch;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: AppSpacing.medium * MediaQuery.textScalerOf(context).scale(1)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.small,
      children: [
        const Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('LAURUM', variant: AppTextVariant.bodyStrong, color: AppColors.primary),
              AppText('Antrean', variant: AppTextVariant.titleRoot, color: AppColors.primaryInk),
            ],
          ),
        ),
        AppIconButton(
          icon: searchOpen ? AppIcons.close : AppIcons.search,
          label: searchOpen ? 'Tutup pencarian' : 'Cari antrean',
          onPressed: onSearch,
        ),
      ],
    ),
  );
}
