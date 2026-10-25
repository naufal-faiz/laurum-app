import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/printer/pages/printer_settings.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';
import 'package:laurum/shared/widgets/organisms/receipt_toggle_list.dart';

class PrinterSettingsPage extends ConsumerWidget {
  const PrinterSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printer = ref.watch(printerSettingsProvider).value;
    if (printer == null) return const SizedBox.shrink();
    final settings = printer.settings;
    final controller = ref.read(printerSettingsProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (printer.notice != null) BannerMessage(message: printer.notice!),
        const SectionHeader(title: 'Ukuran kertas'),
        Wrap(
          spacing: AppSpacing.cardGap,
          children: [
            for (final paper in [58, 80])
              AppChip(
                '$paper mm',
                selected: settings.paperMm == paper,
                onPressed: () => controller.edit(paperMm: paper),
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
                onPressed: () => controller.edit(fontSize: size),
              ),
          ],
        ),
        const SectionHeader(title: 'Elemen tampilan nota'),
        ReceiptToggleList(
          showAddress: settings.showAddress,
          showCustomer: settings.showCustomer,
          showSavings: settings.showSavings,
          showNote: settings.showNote,
          onAddressChanged: (value) => controller.edit(showAddress: value),
          onCustomerChanged: (value) => controller.edit(showCustomer: value),
          onSavingsChanged: (value) => controller.edit(showSavings: value),
          onNoteChanged: (value) => controller.edit(showNote: value),
        ),
        LabeledField(
          label: 'Teks penutup struk',
          child: AppTextField(
            label: 'Teks penutup struk',
            hint: 'Terima kasih atas kepercayaan Anda',
            value: printer.profile.receiptFooter,
            maxLines: 2,
            onChanged: (value) => controller.edit(footer: value),
          ),
        ),
        LabeledField(
          label: 'Catatan khusus nota',
          child: AppTextField(
            label: 'Catatan khusus nota',
            hint: 'Pakaian bersih, wangi & rapi',
            value: printer.profile.receiptNote,
            maxLines: 2,
            onChanged: (value) => controller.edit(note: value),
          ),
        ),
      ],
    );
  }
}
