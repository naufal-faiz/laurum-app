import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';
import 'package:laurum/features/orders/state/payment_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

const paymentMethods = [PayMethod.tunai, PayMethod.qris, PayMethod.transfer];
const paymentMethodLabels = ['Tunai', 'QRIS', 'Transfer'];

class PaymentRecordSheet extends ConsumerWidget {
  const PaymentRecordSheet({required this.data, super.key});
  final OrderDetailData data;

  static Future<void> show(BuildContext context, WidgetRef ref, OrderDetailData data) {
    ref.read(paymentDraftProvider.notifier).start(data.outstanding);
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Catat pembayaran',
      subtitle: 'Sisa piutang ${Formatters.rupiah(data.outstanding)}',
      child: PaymentRecordSheet(data: data),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(paymentDraftProvider);
    final actions = ref.watch(orderPaymentProvider);
    final busy = actions.saving;
    final valid = draft.amount > 0 && draft.amount <= data.outstanding;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        if (actions.error != null)
          BannerMessage(message: actions.error!, variant: BannerMessageVariant.error),
        AppText(Formatters.rupiah(draft.amount), variant: AppTextVariant.figure),
        if (draft.amount > data.outstanding)
          const AppText('Nominal melebihi sisa piutang.', variant: AppTextVariant.caption),
        ChipBar(
          labels: paymentMethodLabels,
          selectedIndex: paymentMethods.indexOf(draft.method),
          onSelected: (index) =>
              ref.read(paymentDraftProvider.notifier).setMethod(paymentMethods[index]),
        ),
        Numpad(onKey: ref.read(paymentDraftProvider.notifier).key),
      ],
    );
    return SheetScaffold(
      footer: AppButton(
        'Simpan pembayaran',
        onPressed: valid && !busy
            ? () async {
                final ok = await ref
                    .read(orderPaymentProvider.notifier)
                    .record(
                      data,
                      amount: draft.amount,
                      method: draft.method,
                      received: draft.amount,
                    );
                if (ok && context.mounted) Navigator.of(context).pop();
              }
            : null,
      ),
      child: body,
    );
  }
}
