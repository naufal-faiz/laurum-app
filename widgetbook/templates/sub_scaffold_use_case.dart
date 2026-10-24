import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

const _body = Padding(
  padding: EdgeInsets.all(AppSpacing.screenPadding),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      AppCard(child: AppText('Konten halaman turunan tanpa nav bawah.')),
      AppCard(child: AppText('Slot body bebas diisi halaman.')),
    ],
  ),
);

final subScaffoldUseCases = [
  WidgetbookUseCase(
    name: 'Dengan aksi',
    builder: (context) => SubScaffold(
      title: 'Detail order',
      backLabel: 'Kembali',
      onBack: () {},
      trailing: const AppText('Ubah'),
      body: _body,
    ),
  ),
  WidgetbookUseCase(
    name: 'Tanpa aksi',
    builder: (context) => SubScaffold(
      title: 'Detail order',
      backLabel: 'Kembali',
      onBack: () {},
      body: _body,
    ),
  ),
];
