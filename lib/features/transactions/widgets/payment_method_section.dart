import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/checkout_data.dart';
import 'package:laurum/features/transactions/state/payment_quote.dart';
import 'package:laurum/features/transactions/widgets/payment_change_section.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

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
  Widget build(BuildContext context) {
    final excess = quote.change + quote.deposit;
    return checkout.payTerm == PayTerm.cod
        ? const BannerMessage(
            message: 'Pelanggan membayar saat struk/barang diterima. Order tetap di antrean sampai pembayaran dicatat.',
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.cardGap,
            children: [
              const AppText('Metode pembayaran', variant: AppTextVariant.section),
              for (final (index, label) in const ['Tunai', 'QRIS', 'Transfer'].indexed)
                SelectionTile(
                  label: label,
                  subtitle: const [
                    'Uang diterima langsung',
                    'Scan semua e-wallet & bank',
                    'BCA · Mandiri · BRI · DLL',
                  ][index],
                  selected: checkout.method.index.clamp(0, 2) == index,
                  icon: const [AppIcons.wallet, AppIcons.qrCode, AppIcons.reports][index],
                  onPressed: () => onMethod(PayMethod.values[index]),
                ),
              AppCard(
                padding: EdgeInsets.zero,
                child: MenuRow(
                  label: 'Uang diterima',
                  subtitle: Formatters.rupiah(quote.received),
                  icon: AppIcons.wallet,
                  onTap: onAmount,
                ),
              ),
              if (quote.outstanding > 0)
                BannerMessage(
                  message: 'Sisa ${Formatters.rupiah(quote.outstanding)} masuk piutang',
                  variant: BannerMessageVariant.error,
                ),
              if (!quote.valid)
                BannerMessage(
                  variant: BannerMessageVariant.error,
                  message: quote.received == 0
                      ? 'Isi jumlah atau pilih Bayar nanti (COD)'
                      : 'Nominal melebihi sisa tagihan untuk metode ini.',
                ),
              if (excess > 0)
                PaymentChangeSection(
                  amount: excess,
                  saveExcess: checkout.saveExcess,
                  onExcess: onExcess,
                ),
            ],
          );
  }
}
