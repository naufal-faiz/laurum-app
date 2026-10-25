import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/money.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_molecule_tokens.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/weight_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/organisms/numpad.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';

class WeightInputSheet extends ConsumerWidget {
  const WeightInputSheet({super.key});

  static Future<void> show(BuildContext context, WidgetRef ref, String serviceId) {
    final line = ref.read(transactionDraftProvider).lineFor(serviceId);
    if (line == null) return Future.value();
    ref.read(weightEditProvider.notifier).start(line);
    final kilo = line.service.kind == ServiceKind.kiloan;
    return AppBottomSheet.show<void>(
      context: context,
      title: '${kilo ? 'Berat' : 'Jumlah'} ${line.service.name}',
      subtitle: '${Formatters.rupiah(line.service.price)} / ${kilo ? 'kg' : 'pcs'}',
      child: const WeightInputSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(weightEditProvider);
    final line = ref.watch(transactionDraftProvider).lineFor(edit.serviceId);
    if (line == null) return const SizedBox.shrink();
    final kilo = line.service.kind == ServiceKind.kiloan;
    final milli = edit.milli;
    final quantity = kilo
        ? Formatters.berat(milli < 500 ? 500 : milli)
        : Formatters.jumlah(milli < 1000 ? 1 : milli ~/ 1000);
    final total = lineTotal(
      qtyMilli: milli < line.step ? line.step : milli,
      unitPrice: line.service.price,
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        AppText(quantity, variant: AppTextVariant.figure),
        AppText(
          '$quantity x ${Formatters.rupiah(line.service.price)} = ${Formatters.rupiah(total)}',
          color: AppColors.ink2,
        ),
        if (kilo)
          Wrap(
            spacing: AppMoleculeTokens.gap,
            children: [
              for (final delta in [500, 1000, 5000])
                AppChip(
                  '+${Formatters.berat(delta)}',
                  onPressed: () => ref.read(weightEditProvider.notifier).add(delta),
                ),
            ],
          ),
        Numpad(
          variant: kilo ? NumpadVariant.decimal : NumpadVariant.standard,
          onKey: ref.read(weightEditProvider.notifier).key,
        ),
      ],
    );
    return SheetScaffold(
      footer: AppButton(
        kilo ? 'Simpan berat' : 'Simpan jumlah',
        onPressed: () {
          final current = ref.read(weightEditProvider).milli;
          final qty = current < line.step ? line.step : current;
          ref.read(transactionDraftProvider.notifier).setQuantity(line.service.id, qty);
          Navigator.of(context).pop();
        },
      ),
      child: body,
    );
  }
}
