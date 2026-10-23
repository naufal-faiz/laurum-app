import 'package:widgetbook/widgetbook.dart';

import 'app_bar_root_use_case.dart';
import 'app_bar_sub_use_case.dart';
import 'chip_bar_use_case.dart';
import 'footer_bar_use_case.dart';
import 'nominal_chips_use_case.dart';
import 'period_tabs_use_case.dart';
import 'stepper_field_use_case.dart';

final m3Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'ChipBar', useCases: [chipBarUseCase]),
  WidgetbookComponent(name: 'PeriodTabs', useCases: [periodTabsUseCase]),
  WidgetbookComponent(name: 'NominalChips', useCases: [nominalChipsUseCase]),
  WidgetbookComponent(name: 'StepperField', useCases: [stepperFieldUseCase]),
  WidgetbookComponent(name: 'AppBarSub', useCases: [appBarSubUseCase]),
  WidgetbookComponent(name: 'AppBarRoot', useCases: [appBarRootUseCase]),
  WidgetbookComponent(name: 'FooterBar', useCases: [footerBarUseCase]),
];
