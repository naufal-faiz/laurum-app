import 'package:widgetbook/widgetbook.dart';

import 'bottom_nav_bar_use_case.dart';
import 'customer_row_use_case.dart';
import 'expense_row_use_case.dart';
import 'order_card_use_case.dart';
import 'savings_row_use_case.dart';
import 'service_row_use_case.dart';

final o1Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'SavingsRow', useCases: [savingsRowUseCase]),
  WidgetbookComponent(name: 'ExpenseRow', useCases: [expenseRowUseCase]),
  WidgetbookComponent(name: 'OrderCard', useCases: [orderCardUseCase]),
  WidgetbookComponent(name: 'BottomNavBar', useCases: [bottomNavBarUseCase]),
  WidgetbookComponent(name: 'ServiceRow', useCases: [serviceRowUseCase]),
  WidgetbookComponent(name: 'CustomerRow', useCases: [customerRowUseCase]),
];
