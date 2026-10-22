import 'package:widgetbook/widgetbook.dart';

import 'date_group_header_use_case.dart';
import 'info_row_use_case.dart';
import 'locked_row_use_case.dart';
import 'menu_row_use_case.dart';
import 'progress_row_use_case.dart';
import 'section_header_use_case.dart';
import 'stat_tile_use_case.dart';
import 'toggle_row_use_case.dart';

final m1Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'SectionHeader', useCases: [sectionHeaderUseCase]),
  WidgetbookComponent(name: 'InfoRow', useCases: [infoRowUseCase]),
  WidgetbookComponent(name: 'StatTile', useCases: [statTileUseCase]),
  WidgetbookComponent(name: 'DateGroupHeader', useCases: [dateGroupHeaderUseCase]),
  WidgetbookComponent(name: 'ProgressRow', useCases: [progressRowUseCase]),
  WidgetbookComponent(name: 'MenuRow', useCases: [menuRowUseCase]),
  WidgetbookComponent(name: 'ToggleRow', useCases: [toggleRowUseCase]),
  WidgetbookComponent(name: 'LockedRow', useCases: [lockedRowUseCase]),
];
