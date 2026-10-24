import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/confirm_modal.dart';
import 'package:widgetbook/widgetbook.dart';

final confirmModalUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        SizedBox(
          height: 360,
          child: ConfirmModal(
            title: 'Keluar tanpa menyimpan?',
            message: 'Nota A-0143 belum disimpan dan akan hilang.',
            confirmLabel: 'Keluar tanpa simpan',
          ),
        ),
        SizedBox(
          height: 360,
          child: ConfirmModal(
            title: 'Hapus pengeluaran ini?',
            message: 'Rp110.000 - Deterjen cair Matic 2 jerigen (10 L).',
            confirmLabel: 'Hapus',
            destructive: true,
            icon: AppIcons.alert,
          ),
        ),
      ],
    ),
  ),
);
