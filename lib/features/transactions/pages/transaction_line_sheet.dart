import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/pages/transaction_draft.dart';
import 'package:laurum/features/transactions/pages/weight_input_sheet.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/stepper_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class TransactionLineSheet extends ConsumerWidget {
  const TransactionLineSheet({required this.serviceId, super.key});
  final String serviceId;

  static Future<void> show(BuildContext context, WidgetRef ref, String serviceId) {
    final line = ref.read(transactionDraftProvider).lineFor(serviceId);
    if (line == null) return Future.value();
    return AppBottomSheet.show<void>(
      context: context,
      title: line.service.name,
      subtitle: line.priceLabel,
      child: TransactionLineSheet(serviceId: serviceId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = ref.watch(transactionDraftProvider).lineFor(serviceId);
    if (line == null) return const SizedBox.shrink();
    final notifier = ref.read(transactionDraftProvider.notifier);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppText(line.quantityLabel, variant: AppTextVariant.figure),
        AppText(
          '${line.quantityLabel} x ${Formatters.rupiah(line.service.price)} = '
          '${Formatters.rupiah(line.total)}',
          color: AppColors.ink2,
        ),
        StepperField(
          value: line.quantityLabel,
          decreaseLabel: 'Kurangi ${line.service.name}',
          increaseLabel: 'Tambah ${line.service.name}',
          editLabel: 'Ubah jumlah ${line.service.name}',
          onDecrease: line.qtyMilli <= line.step
              ? null
              : () => notifier.setQuantity(serviceId, line.qtyMilli - line.step),
          onIncrease: () => notifier.setQuantity(serviceId, line.qtyMilli + line.step),
          onEdit: () => WeightInputSheet.show(context, ref, serviceId),
        ),
      ],
    );
    return SheetScaffold(
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.cardGap,
        children: [
          AppButton('Selesai', onPressed: () => Navigator.of(context).pop()),
          AppButton(
            'Hapus layanan',
            variant: AppButtonVariant.destructiveOutline,
            onPressed: () {
              notifier.remove(serviceId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      child: body,
    );
  }
}
