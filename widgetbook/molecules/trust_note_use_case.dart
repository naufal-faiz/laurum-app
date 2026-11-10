import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/molecules/trust_note.dart';
import 'package:widgetbook/widgetbook.dart';

final trustNoteUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => const Padding(
    padding: EdgeInsets.all(AppSpacing.screenPadding),
    child: TrustNote(text: 'Data usaha kamu aman & terenkripsi'),
  ),
);
