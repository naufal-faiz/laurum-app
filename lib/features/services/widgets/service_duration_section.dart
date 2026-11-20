import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/shared/widgets/atoms/app_divider.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class ServiceDurationSection extends StatelessWidget {
  const ServiceDurationSection({
    required this.state,
    required this.onDuration,
    required this.onActive,
    super.key,
  });
  final ServiceEditState state;
  final ValueChanged<int> onDuration;
  final ValueChanged<bool> onActive;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.medium,
    children: [
      const Row(
        children: [
          Expanded(
            child: AppText(
              'Estimasi selesai',
              variant: AppTextVariant.label,
              color: AppColors.primaryInk,
            ),
          ),
          SizedBox(width: AppSpacing.small),
          Flexible(
            child: AppText(
              'Standar durasi',
              variant: AppTextVariant.caption,
              color: AppColors.ink3,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
      ChipBar(
        labels: const ['1 hari', '2 hari', '3 hari', '4 hari', '5 hari'],
        selectedIndex: state.durationDays - 1,
        onSelected: (index) => onDuration(index + 1),
      ),
      const AppDivider(),
      ToggleRow(
        label: 'Layanan aktif',
        description: 'Muncul di kasir saat membuat nota',
        icon: AppIcons.power,
        compact: true,
        value: state.isActive,
        onChanged: state.busy ? null : onActive,
      ),
    ],
  );
}
