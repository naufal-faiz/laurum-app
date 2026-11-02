import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/features/orders/state/order_detail_data.dart';
import 'package:laurum/features/orders/state/order_payment_controller.dart';
import 'package:laurum/features/orders/state/payment_draft.dart';
import 'package:laurum/features/orders/widgets/payment_record_input_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class PaymentRecordSheet extends ConsumerWidget {
  const PaymentRecordSheet({required this.data, this.completeOnPayment = false, super.key});
  final OrderDetailData data;
  final bool completeOnPayment;
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    OrderDetailData data, {
    bool completeOnPayment = false,
  }) {
    ref.read(paymentDraftProvider.notifier).start(data.outstanding);
    ref.read(orderPaymentProvider.notifier).clearError();
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Catat pembayaran',
      subtitle: 'Sisa piutang ${Formatters.rupiah(data.outstanding)}',
      child: PaymentRecordSheet(data: data, completeOnPayment: completeOnPayment),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(paymentDraftProvider);
    final actions = ref.watch(orderPaymentProvider);
    final controller = ref.read(paymentDraftProvider.notifier);
    final valid =
        draft.amount > 0 && (draft.method == PayMethod.tunai || draft.amount <= data.outstanding);
    return SheetScaffold(
      footer: AppButton(
        'Simpan pembayaran',
        onPressed: valid && !actions.saving
            ? () async {
                final ok = await ref
                    .read(orderPaymentProvider.notifier)
                    .record(
                      data,
                      amount: draft.amount.clamp(0, data.outstanding),
                      method: draft.method,
                      received: draft.amount,
                      saveExcess: draft.saveExcess,
                      completeOnPayment: completeOnPayment,
                    );
                if (ok && context.mounted) Navigator.of(context).pop();
              }
            : null,
      ),
      child: PaymentRecordInputSection(
        amount: draft.amount,
        due: data.outstanding,
        method: draft.method,
        saveExcess: draft.saveExcess,
        error: actions.error,
        onMethod: controller.setMethod,
        onKey: controller.key,
        onExcess: (save) => controller.setExcess(save: save),
      ),
    );
  }
}
