import 'package:widgetbook/widgetbook.dart';

import 'banner_message_use_case.dart';
import 'callout_ai_use_case.dart';
import 'empty_state_use_case.dart';
import 'labeled_field_use_case.dart';
import 'notice_ai_use_case.dart';
import 'sync_indicator_use_case.dart';

final m2Components = <WidgetbookComponent>[
  WidgetbookComponent(name: 'LabeledField', useCases: [labeledFieldUseCase]),
  WidgetbookComponent(name: 'BannerMessage', useCases: [bannerMessageUseCase]),
  WidgetbookComponent(name: 'NoticeAi', useCases: [noticeAiUseCase]),
  WidgetbookComponent(name: 'CalloutAi', useCases: [calloutAiUseCase]),
  WidgetbookComponent(name: 'EmptyState', useCases: [emptyStateUseCase]),
  WidgetbookComponent(name: 'SyncIndicator', useCases: [syncIndicatorUseCase]),
];
