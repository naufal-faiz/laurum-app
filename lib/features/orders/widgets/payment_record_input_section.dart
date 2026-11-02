import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

class PaymentRecordInputSection extends StatelessWidget {
  const PaymentRecordInputSection({
    required this.amount,
    required this.due,
    required this.method,
    required this.saveExcess,
    required this.onMethod,
    required this.onExcess,
    required this.onKey,
    this.error,
    super.key,
  });
  final int amount, due;
  final PayMethod method;
  final bool saveExcess;
  final String? error;
  final ValueChanged<PayMethod> onMethod;
  final ValueChanged<bool> onExcess;
  final ValueChanged<AppNumpadKeyValue> onKey;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      if (error != null) BannerMessage(message: error!, variant: BannerMessageVariant.error),
      AppText(Formatters.rupiah(amount), variant: AppTextVariant.figure),
      ChipBar(
        labels: const ['Tunai', 'QRIS', 'Transfer'],
        selectedIndex: method.index,
        onSelected: (i) => onMethod(PayMethod.values[i]),
      ),
      if (method == PayMethod.tunai && amount > due) ...[
        AppText('Kelebihan ${Formatters.rupiah(amount - due)}'),
        ChipBar(
          labels: const ['Kembalian', 'Simpan ke tabungan'],
          selectedIndex: saveExcess ? 1 : 0,
          onSelected: (i) => onExcess(i == 1),
        ),
      ],
      if (method != PayMethod.tunai && amount > due)
        const BannerMessage(
          message: 'Nominal melebihi sisa tagihan untuk metode ini.',
          variant: BannerMessageVariant.error,
        ),
      Numpad(onKey: onKey),
    ],
  );
}
