import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/shared/widgets/organisms/savings_row.dart';
import 'package:widgetbook/widgetbook.dart';

final savingsRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        for (final entry in savingsFixtures.take(3).toList().reversed)
          SavingsRow(
            label: entry.note,
            timeLabel:
                '${Formatters.tanggal(entry.createdAt, ringkas: true)} ${Formatters.jam(entry.createdAt)}',
            kind: entry.kind,
            amount: entry.amount,
            balance: savingsBalance(
              savingsFixtures.where(
                (s) => s.customerId == entry.customerId && !s.createdAt.isAfter(entry.createdAt),
              ),
            ),
            methodLabel: entry.kind == SavingsKind.setor ? 'Tunai' : null,
            reference: entry.orderId == null ? null : 'A-0115 (Bed cover)',
          ),
        SavingsRow(
          label: 'Penyesuaian (varian)',
          timeLabel: '',
          kind: SavingsKind.penyesuaian,
          amount: -savingsFixtures.first.amount,
          balance: 0,
          note: 'Contoh tampilan koreksi',
        ),
      ],
    ),
  ),
);
