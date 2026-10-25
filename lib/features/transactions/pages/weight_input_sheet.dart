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
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
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
    final quantity = kilo ? Formatters.berat(milli) : Formatters.jumlah(milli ~/ 1000);
    final minimum = kilo ? Formatters.berat(line.step) : Formatters.jumlah(line.step ~/ 1000);
    final valid = milli >= line.step;
    final total = lineTotal(qtyMilli: milli, unitPrice: line.service.price);
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppMoleculeTokens.gap,
      children: [
        AppText(kilo ? Formatters.beratInput(edit.text) : quantity, variant: AppTextVariant.figure),
        AppText(
          '$quantity x ${Formatters.rupiah(line.service.price)} = ${Formatters.rupiah(total)}',
          color: AppColors.ink2,
        ),
        if (!valid)
          BannerMessage(
            message: 'Minimal $minimum',
            variant: BannerMessageVariant.error,
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
        onPressed: valid
            ? () {
                final current = ref.read(weightEditProvider).milli;
                if (current < line.step) return;
                ref.read(transactionDraftProvider.notifier).setQuantity(line.service.id, current);
                Navigator.of(context).pop();
              }
            : null,
      ),
      child: body,
    );
  }
}
