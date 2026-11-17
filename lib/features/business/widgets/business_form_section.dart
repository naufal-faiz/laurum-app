import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class BusinessFormSection extends StatelessWidget {
  const BusinessFormSection({
    required this.name,
    required this.address,
    required this.phone,
    required this.footer,
    required this.busy,
    required this.onName,
    required this.onAddress,
    required this.onPhone,
    required this.onFooter,
    this.nameError,
    super.key,
  });
  final String name, address, phone, footer;
  final bool busy;
  final String? nameError;
  final ValueChanged<String> onName, onAddress, onPhone, onFooter;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.small,
    children: [
      const AppText('DETAIL USAHA', variant: AppTextVariant.label, color: AppColors.ink3),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.mediumLarge,
          children: [
            LabeledField(
              label: 'Nama usaha',
              errorText: nameError,
              child: AppTextField(
                label: 'Nama usaha',
                value: name,
                enabled: !busy,
                selectAllOnFocus: true,
                onChanged: onName,
              ),
            ),
            LabeledField(
              label: 'Alamat',
              child: AppTextField(
                label: 'Alamat',
                value: address,
                enabled: !busy,
                selectAllOnFocus: true,
                minLines: 2,
                maxLines: 2,
                onChanged: onAddress,
              ),
            ),
            LabeledField(
              label: 'Nomor telepon',
              helperText: 'Nomor telepon ditampilkan di struk.',
              child: AppTextField(
                label: 'Nomor telepon',
                value: phone,
                enabled: !busy,
                selectAllOnFocus: true,
                keyboardType: TextInputType.phone,
                onChanged: onPhone,
              ),
            ),
            LabeledField(
              label: 'Catatan kaki struk',
              helperText: 'Catatan tambahan struk diatur di layar Printer dan struk.',
              child: AppTextField(
                label: 'Catatan kaki struk',
                value: footer,
                enabled: !busy,
                selectAllOnFocus: true,
                minLines: 2,
                maxLines: 2,
                onChanged: onFooter,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
