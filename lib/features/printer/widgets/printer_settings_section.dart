import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/state/printer_settings_edit.dart';
import 'package:laurum/features/printer/widgets/printer_elements_section.dart';
import 'package:laurum/features/printer/widgets/printer_format_section.dart';
import 'package:laurum/features/printer/widgets/printer_message_section.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class PrinterSettingsSection extends StatelessWidget {
  const PrinterSettingsSection({
    required this.printer,
    required this.onEdit,
    required this.onNotice,
    super.key,
  });
  final PrinterSettingsState printer;
  final PrinterSettingsEdit onEdit;
  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    final settings = printer.settings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (printer.notice != null)
          BannerMessage(
            message: printer.notice!,
            variant: printer.noticeSuccess
                ? BannerMessageVariant.success
                : BannerMessageVariant.info,
          ),
        PrinterFormatSection(
          paperMm: settings.paperMm,
          fontSize: settings.fontSize,
          onEdit: onEdit,
          onNotice: onNotice,
        ),
        PrinterElementsSection(
          showAddress: settings.showAddress,
          showCustomer: settings.showCustomer,
          showSavings: settings.showSavings,
          showNote: settings.showNote,
          onAddressChanged: (value) => onEdit(showAddress: value),
          onCustomerChanged: (value) => onEdit(showCustomer: value),
          onSavingsChanged: (value) => onEdit(showSavings: value),
          onNoteChanged: (value) => onEdit(showNote: value),
        ),
        PrinterMessageSection(
          footer: printer.profile.receiptFooter,
          note: printer.profile.receiptNote,
          onFooterChanged: (value) => onEdit(footer: value),
          onNoteChanged: (value) => onEdit(note: value),
        ),
      ],
    );
  }
}
