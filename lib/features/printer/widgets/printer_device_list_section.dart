import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

class PrinterDeviceListSection extends StatelessWidget {
  const PrinterDeviceListSection({
    required this.devices,
    required this.saved,
    required this.busy,
    required this.onSelect,
    super.key,
  });
  final List<PrinterDevice> devices;
  final PrinterDevice? saved;
  final bool busy;
  final ValueChanged<PrinterDevice> onSelect;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      if (saved != null) ...[
        const SectionHeader(title: 'Printer tersimpan di perangkat'),
        AppCard(
          padding: EdgeInsets.zero,
          child: MenuRow(
            label: saved!.name,
            subtitle: saved!.id,
            icon: AppIcons.printer,
            onTap: busy ? null : () => onSelect(saved!),
          ),
        ),
      ],
      if (devices.any((device) => device.id != saved?.id)) ...[
        const SectionHeader(title: 'Printer terdeteksi'),
        for (final device in devices.where((device) => device.id != saved?.id))
          AppCard(
            padding: EdgeInsets.zero,
            child: MenuRow(
              label: device.name,
              subtitle: device.id,
              icon: AppIcons.printer,
              onTap: busy ? null : () => onSelect(device),
            ),
          ),
      ],
    ],
  );
}
