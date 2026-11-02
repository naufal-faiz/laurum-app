import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/checkout_data.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({
    required this.checkout,
    required this.quote,
    required this.onMethod,
    required this.onAmount,
    required this.onExcess,
    super.key,
  });
  final CheckoutState checkout;
  final PaymentQuote quote;
  final ValueChanged<PayMethod> onMethod;
  final ValueChanged<bool> onExcess;
  final VoidCallback onAmount;
  @override
  Widget build(BuildContext context) => checkout.payTerm == PayTerm.cod
      ? const BannerMessage(
          message: 'Pelanggan membayar saat struk/barang diterima. Order tetap di antrean sampai pembayaran dicatat.',
        )
      : AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              const AppText('Metode pembayaran', variant: AppTextVariant.section),
              ChipBar(
                labels: const ['Tunai', 'QRIS', 'Transfer'],
                selectedIndex: checkout.method.index.clamp(0, 2),
                onSelected: (i) => onMethod(PayMethod.values[i]),
              ),
              MenuRow(
                label: 'Uang diterima',
                subtitle: Formatters.rupiah(quote.received),
                icon: AppIcons.wallet,
                onTap: onAmount,
              ),
              if (quote.outstanding > 0)
                AppText('Sisa ${Formatters.rupiah(quote.outstanding)} masuk piutang'),
              if (!quote.valid)
                BannerMessage(
                  variant: BannerMessageVariant.error,
                  message: quote.received == 0
                      ? 'Isi jumlah atau pilih Bayar nanti (COD)'
                      : 'Nominal melebihi sisa tagihan untuk metode ini.',
                ),
              if (quote.change + quote.deposit > 0) ...[
                AppText(
                  '${checkout.saveExcess ? 'Simpan ke tabungan' : 'Kembali'} ${Formatters.rupiah(quote.change + quote.deposit)}',
                ),
                ChipBar(
                  labels: const ['Kembalian', 'Simpan ke tabungan'],
                  selectedIndex: checkout.saveExcess ? 1 : 0,
                  onSelected: (i) => onExcess(i == 1),
                ),
              ],
            ],
          ),
        );
}
