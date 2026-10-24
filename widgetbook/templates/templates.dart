import 'package:widgetbook/widgetbook.dart';

import 'auth_scaffold_use_case.dart';
import 'form_scaffold_use_case.dart';
import 'root_scaffold_use_case.dart';
import 'sheet_scaffold_use_case.dart';
import 'sub_scaffold_use_case.dart';

final templateComponents = <WidgetbookComponent>[
  WidgetbookComponent(name: 'RootScaffold', useCases: rootScaffoldUseCases),
  WidgetbookComponent(name: 'SubScaffold', useCases: subScaffoldUseCases),
  WidgetbookComponent(name: 'FormScaffold', useCases: formScaffoldUseCases),
  WidgetbookComponent(name: 'SheetScaffold', useCases: sheetScaffoldUseCases),
  WidgetbookComponent(name: 'AuthScaffold', useCases: [authScaffoldUseCase]),
];
