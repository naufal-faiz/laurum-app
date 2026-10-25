import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class ServiceEditFieldsSection extends StatelessWidget {
  const ServiceEditFieldsSection({
    required this.state,
    required this.onName,
    required this.onKind,
    required this.onPrice,
    required this.onDuration,
    required this.onActive,
    super.key,
  });

  final ServiceEditState state;
  final ValueChanged<String> onName, onPrice;
  final ValueChanged<int> onKind, onDuration;
  final ValueChanged<bool> onActive;

  @override
  Widget build(BuildContext context) {
    final helper = state.price > 0
        ? '${Formatters.rupiah(state.price)} • Nominal sebelum diskon nota transaksi atau promo kasir.'
        : 'Nominal sebelum diskon nota transaksi atau promo kasir.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (state.isEdit)
          const AppText(
            'Perubahan harga tidak memengaruhi nota yang sudah tercetak.',
            variant: AppTextVariant.caption,
          ),
        LabeledField(
          label: 'Nama layanan',
          errorText: state.nameError,
          child: AppTextField(
            label: 'Nama layanan',
            value: state.name,
            enabled: !state.busy,
            onChanged: onName,
          ),
        ),
        LabeledField(
          label: 'Tipe layanan',
          child: ChipBar(
            labels: const ['Kiloan (per kg)', 'Satuan (per pcs)'],
            selectedIndex: state.kind == ServiceKind.kiloan ? 0 : 1,
            onSelected: onKind,
          ),
        ),
        LabeledField(
          label: 'Harga (per ${state.unitLabel})',
          helperText: helper,
          errorText: state.priceError,
          child: AppTextField(
            label: 'Harga',
            hint: '9000',
            value: state.priceText,
            enabled: !state.busy,
            keyboardType: TextInputType.number,
            selectAllOnFocus: state.priceText.isNotEmpty,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            onChanged: onPrice,
          ),
        ),
        LabeledField(
          label: 'Estimasi selesai',
          helperText: 'Standar durasi',
          child: ChipBar(
            labels: const ['1 hari', '2 hari', '3 hari', '4 hari', '5 hari'],
            selectedIndex: state.durationDays - 1,
            onSelected: (index) => onDuration(index + 1),
          ),
        ),
        ToggleRow(
          label: 'Layanan aktif',
          description: 'Layanan aktif langsung muncul di kasir saat membuat nota transaksi',
          value: state.isActive,
          onChanged: state.busy ? null : onActive,
        ),
        if (state.notice != null)
          BannerMessage(message: state.notice!, variant: BannerMessageVariant.error),
      ],
    );
  }
}
