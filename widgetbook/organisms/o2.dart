import 'package:widgetbook/widgetbook.dart';

import 'numpad_use_case.dart';
import 'receipt_preview_use_case.dart';
import 'receipt_toggle_list_use_case.dart';

final o2Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'ReceiptPreview', useCases: [receiptPreviewUseCase]),
  WidgetbookComponent(name: 'ReceiptToggleList', useCases: [receiptToggleListUseCase]),
  WidgetbookComponent(name: 'Numpad', useCases: [numpadUseCase]),
];
