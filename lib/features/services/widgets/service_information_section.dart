import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_type_section.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class ServiceInformationSection extends StatelessWidget {
  const ServiceInformationSection({
    required this.state,
    required this.onName,
    required this.onKind,
    required this.onPrice,
    super.key,
  });
  final ServiceEditState state;
  final ValueChanged<String> onName, onPrice;
  final ValueChanged<int> onKind;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.mediumLarge,
    children: [
      LabeledField(
        label: 'Nama layanan',
        errorText: state.nameError,
        child: AppTextField(
          label: 'Nama layanan',
          value: state.name,
          hint: 'cth. Cuci setrika reguler',
          leadingIcon: AppIcons.service,
          dense: true,
          enabled: !state.busy,
          onChanged: onName,
        ),
      ),
      LabeledField(
        label: 'Tipe layanan',
        child: ServiceTypeSection(kind: state.kind, onKind: onKind),
      ),
      LabeledField(
        label: 'Harga per ${state.unitLabel}',
        errorText: state.priceError,
        helperText: state.price > 0
            ? '${Formatters.rupiah(state.price)} • Nominal sebelum diskon nota transaksi atau promo kasir.'
            : 'Nominal sebelum diskon nota transaksi atau promo kasir.',
        child: AppTextField(
          label: 'Harga',
          hint: '0',
          value: state.priceText,
          dense: true,
          prefixText: 'Rp ',
          enabled: !state.busy,
          trailing: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.medium),
            child: Center(
              widthFactor: 1,
              child: AppText(
                'per ${state.unitLabel}',
                variant: AppTextVariant.caption,
                color: AppColors.ink3,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          selectAllOnFocus: state.priceText.isNotEmpty,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          onChanged: onPrice,
        ),
      ),
    ],
  );
}
