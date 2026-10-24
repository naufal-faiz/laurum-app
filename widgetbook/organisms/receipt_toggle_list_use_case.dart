import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/organisms/receipt_toggle_list.dart';
import 'package:widgetbook/widgetbook.dart';

final receiptToggleListUseCase = WidgetbookUseCase(
  name: 'Semua varian',
  builder: (context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Column(
      spacing: AppSpacing.cardGap,
      children: [
        ReceiptToggleList(
          showAddress: true,
          showCustomer: true,
          showSavings: true,
          showNote: true,
          onAddressChanged: (_) {},
          onCustomerChanged: (_) {},
          onSavingsChanged: (_) {},
          onNoteChanged: (_) {},
        ),
        ReceiptToggleList(
          showAddress: false,
          showCustomer: true,
          showSavings: false,
          showNote: false,
          onAddressChanged: (_) {},
          onCustomerChanged: (_) {},
          onSavingsChanged: (_) {},
          onNoteChanged: (_) {},
        ),
      ],
    ),
  ),
);
