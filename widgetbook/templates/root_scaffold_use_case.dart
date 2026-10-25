import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

const _body = Padding(
  padding: EdgeInsets.all(AppSpacing.screenPadding),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      AppText('Ringkasan hari ini', variant: AppTextVariant.section),
      AppCard(child: AppText('Konten layar ditempatkan pada slot body.')),
      AppCard(child: AppText('BottomNavBar dan aksi Transaksi berasal dari template.')),
    ],
  ),
);

final rootScaffoldUseCases = [
  WidgetbookUseCase(
    name: 'Navigasi dan Transaksi',
    builder: (context) => RootScaffold(
      title: 'Antrean',
      accountLabel: 'Akun',
      activeIndex: 0,
      onCreate: () {},
      onAccount: () {},
      onTabSelected: (_) {},
      body: _body,
    ),
  ),
  WidgetbookUseCase(
    name: 'Offline',
    builder: (context) => RootScaffold(
      title: 'Antrean',
      accountLabel: 'Akun',
      activeIndex: 0,
      syncState: SyncState.offline,
      onAccount: () {},
      onTabSelected: (_) {},
      body: _body,
    ),
  ),
];
