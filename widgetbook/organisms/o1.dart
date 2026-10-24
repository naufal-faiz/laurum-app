import 'package:widgetbook/widgetbook.dart';

import 'bottom_nav_bar_use_case.dart';
import 'customer_row_use_case.dart';
import 'service_row_use_case.dart';

final o1Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'BottomNavBar', useCases: [bottomNavBarUseCase]),
  WidgetbookComponent(name: 'ServiceRow', useCases: [serviceRowUseCase]),
  WidgetbookComponent(name: 'CustomerRow', useCases: [customerRowUseCase]),
];
