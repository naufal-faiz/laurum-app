import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';
import 'package:laurum/shared/widgets/templates/sheet_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';

final appBottomSheetKeyboardUseCase = WidgetbookUseCase(
  name: 'Input dan keyboard',
  builder: (context) => Center(
    child: AppButton(
      'Buka input',
      onPressed: () => AppBottomSheet.show<void>(
        context: context,
        title: 'Input dan keyboard',
        child: SheetScaffold(
          footer: AppButton('Simpan', onPressed: () => Navigator.of(context).pop()),
          child: const AppTextField(label: 'Catatan', hint: 'Catatan'),
        ),
      ),
    ),
  ),
);
