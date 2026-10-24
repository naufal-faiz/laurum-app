import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/form_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

const _body = Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  spacing: AppSpacing.cardGap,
  children: [
    AppCard(child: AppText('Isian formulir ditempatkan pada slot body.')),
    AppCard(child: AppText('Footer sticky berada di luar area gulir.')),
  ],
);

final formScaffoldUseCases = [
  WidgetbookUseCase(
    name: 'Dengan ringkasan',
    builder: (context) => FormScaffold(
      title: 'Catat pengeluaran',
      backLabel: 'Kembali',
      onBack: () {},
      summary: const AppText('Total Rp110.000'),
      body: _body,
      footer: AppButton('Simpan pengeluaran', onPressed: () {}),
    ),
  ),
  WidgetbookUseCase(
    name: 'Tanpa ringkasan',
    builder: (context) => FormScaffold(
      title: 'Catat pengeluaran',
      backLabel: 'Kembali',
      onBack: () {},
      body: _body,
      footer: AppButton('Simpan pengeluaran', onPressed: () {}),
    ),
  ),
];
