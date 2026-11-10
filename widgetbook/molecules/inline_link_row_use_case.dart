import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/inline_link.dart';
import 'package:laurum/shared/widgets/molecules/inline_link_row.dart';
import 'package:widgetbook/widgetbook.dart';

final inlineLinkRowUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.cardGap,
      children: [
        InlineLinkRow(question: 'Belum punya akun?', action: 'Daftar', onTap: () {}),
        const InlineLinkRow(question: 'Sudah punya akun?', action: 'Masuk'),
        Align(
          alignment: Alignment.centerLeft,
          child: InlineLink('Lupa password?', onTap: () {}),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: InlineLink('Lupa password?'),
        ),
      ],
    ),
  ),
);
