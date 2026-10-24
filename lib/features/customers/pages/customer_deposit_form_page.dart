import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/pages/customer_deposit_controller.dart';
import 'package:laurum/features/customers/pages/customer_deposit_state.dart';
import 'package:laurum/features/customers/pages/customer_detail_data.dart';
import 'package:laurum/features/orders/pages/order_detail_data.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';
import 'package:laurum/shared/widgets/molecules/nominal_chips.dart';
import 'package:laurum/shared/widgets/molecules/stat_tile.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';

class CustomerDepositFormPage extends ConsumerWidget {
  const CustomerDepositFormPage({required this.data, super.key});
  final CustomerDetailData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = data.summary.customer;
    final deposit = ref.watch(customerDepositProvider(customer.id));
    final actions = ref.read(customerDepositProvider(customer.id).notifier);
    final balance = data.summary.savings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppCard(
          child: Row(
            children: [
              AppAvatar(initials: customerInitials(customer.name)),
              const SizedBox(width: AppSpacing.cardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(customer.name, variant: AppTextVariant.bodyStrong),
                    AppText(
                      Formatters.telepon(customer.phone),
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        StatTile(label: 'Saldo sekarang', value: Formatters.rupiah(balance)),
        LabeledField(
          label: 'Nominal setoran',
          errorText: deposit.nominalError,
          child: AppText(Formatters.rupiah(deposit.amount), variant: AppTextVariant.figure),
        ),
        NominalChips(
          amounts: const [20000, 50000, 100000],
          onSelected: actions.add,
        ),
        Numpad(onKey: actions.key),
        AppText('Saldo akhir menjadi ${Formatters.rupiah(balance + deposit.amount)}'),
        LabeledField(
          label: 'Metode setoran',
          helperText: 'Setoran dicatat sebagai titipan, bukan omzet.',
          child: ChipBar(
            labels: depositMethodLabels,
            selectedIndex: depositMethods.indexOf(deposit.method),
            onSelected: (index) => actions.setMethod(depositMethods[index]),
          ),
        ),
        AppTextField(
          label: 'Catatan (opsional)',
          hint: 'Misal: titipan kembalian nota A-0142',
          value: deposit.note,
          minLines: 2,
          maxLines: 2,
          onChanged: actions.setNote,
        ),
        if (deposit.error != null)
          BannerMessage(message: deposit.error!, variant: BannerMessageVariant.error),
      ],
    );
  }
}
