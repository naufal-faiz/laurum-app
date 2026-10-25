import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/transactions/state/cash_input.dart';
import 'package:laurum/features/transactions/state/checkout_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/nominal_chips.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class CashInputSheet extends ConsumerWidget {
  const CashInputSheet({required this.due, super.key});
  final int due;

  static Future<void> show(BuildContext context, WidgetRef ref, int due, int current) {
    ref.read(cashInputProvider.notifier).start(current <= 0 ? due : current);
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Uang diterima',
      subtitle: 'Total tagihan ${Formatters.rupiah(due)}',
      child: CashInputSheet(due: due),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(cashInputProvider);
    final amount = int.tryParse(text) ?? 0;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        AppText(Formatters.rupiah(amount), variant: AppTextVariant.figure),
        NominalChips(
          amounts: const [10000, 20000, 50000, 100000],
          selectedAmount: amount,
          increment: false,
          onSelected: ref.read(cashInputProvider.notifier).set,
        ),
        Numpad(onKey: ref.read(cashInputProvider.notifier).key),
      ],
    );
    return SheetScaffold(
      footer: AppButton(
        'Simpan uang diterima',
        onPressed: () {
          ref.read(checkoutControllerProvider.notifier).setReceived(amount, due: due);
          Navigator.of(context).pop();
        },
      ),
      child: body,
    );
  }
}
