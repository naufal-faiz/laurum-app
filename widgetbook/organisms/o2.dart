import 'package:widgetbook/widgetbook.dart';

import 'app_bottom_sheet_use_case.dart';
import 'confirm_modal_use_case.dart';
import 'numpad_use_case.dart';
import 'receipt_preview_use_case.dart';
import 'receipt_toggle_list_use_case.dart';
import 'report_summary_use_case.dart';
import 'top_services_use_case.dart';
import 'weekly_bar_chart_use_case.dart';

final o2Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'ReceiptPreview', useCases: [receiptPreviewUseCase]),
  WidgetbookComponent(name: 'ReceiptToggleList', useCases: [receiptToggleListUseCase]),
  WidgetbookComponent(name: 'Numpad', useCases: [numpadUseCase]),
  WidgetbookComponent(name: 'AppBottomSheet', useCases: [appBottomSheetUseCase]),
  WidgetbookComponent(name: 'ConfirmModal', useCases: [confirmModalUseCase]),
  WidgetbookComponent(name: 'ReportSummary', useCases: [reportSummaryUseCase]),
  WidgetbookComponent(name: 'TopServices', useCases: [topServicesUseCase]),
  WidgetbookComponent(name: 'WeeklyBarChart', useCases: [weeklyBarChartUseCase]),
];
