import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class PrinterMessageSection extends StatelessWidget {
  const PrinterMessageSection({
    required this.footer,
    required this.note,
    required this.onFooterChanged,
    required this.onNoteChanged,
    super.key,
  });
  final String footer, note;
  final ValueChanged<String> onFooterChanged, onNoteChanged;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      spacing: AppSpacing.medium,
      children: [
        LabeledField(
          label: 'Pesan penutup struk',
          child: AppTextField(
            label: 'Pesan penutup struk',
            hint: 'Terima kasih atas kepercayaan Anda',
            value: footer,
            maxLines: 2,
            onChanged: onFooterChanged,
          ),
        ),
        LabeledField(
          label: 'Catatan khusus nota',
          child: AppTextField(
            label: 'Catatan khusus nota',
            hint: 'Pakaian bersih, wangi & rapi',
            value: note,
            maxLines: 2,
            onChanged: onNoteChanged,
          ),
        ),
      ],
    ),
  );
}
