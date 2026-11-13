import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/state/printer_settings.dart';
import 'package:laurum/features/printer/state/printer_settings_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/receipt_toggle_list.dart';

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
        const SectionHeader(title: 'Ukuran kertas'),
        Wrap(
          spacing: AppSpacing.cardGap,
          children: [
            for (final paper in [58, 80])
              AppChip(
                '$paper mm',
                selected: settings.paperMm == paper,
                onPressed: paper == 80
                    ? () => onNotice(
                        'Printer 80 mm masih coming soon. Untuk sekarang gunakan 58 mm.',
                      )
                    : () => onEdit(paperMm: paper),
              ),
          ],
        ),
        const SectionHeader(title: 'Ukuran huruf'),
        Wrap(
          spacing: AppSpacing.cardGap,
          children: [
            for (final size in [11, 13])
              AppChip(
                size == 11 ? 'Normal' : 'Besar',
                selected: settings.fontSize == size,
                onPressed: () => onEdit(fontSize: size),
              ),
          ],
        ),
        const SectionHeader(title: 'Elemen tampilan nota'),
        ReceiptToggleList(
          showAddress: settings.showAddress,
          showCustomer: settings.showCustomer,
          showSavings: settings.showSavings,
          showNote: settings.showNote,
          onAddressChanged: (value) => onEdit(showAddress: value),
          onCustomerChanged: (value) => onEdit(showCustomer: value),
          onSavingsChanged: (value) => onEdit(showSavings: value),
          onNoteChanged: (value) => onEdit(showNote: value),
        ),
        LabeledField(
          label: 'Teks penutup struk',
          child: AppTextField(
            label: 'Teks penutup struk',
            hint: 'Terima kasih atas kepercayaan Anda',
            value: printer.profile.receiptFooter,
            maxLines: 2,
            onChanged: (value) => onEdit(footer: value),
          ),
        ),
        LabeledField(
          label: 'Catatan khusus nota',
          child: AppTextField(
            label: 'Catatan khusus nota',
            hint: 'Pakaian bersih, wangi & rapi',
            value: printer.profile.receiptNote,
            maxLines: 2,
            onChanged: (value) => onEdit(note: value),
          ),
        ),
      ],
    );
  }
}
