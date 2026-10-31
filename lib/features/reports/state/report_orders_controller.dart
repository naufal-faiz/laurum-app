import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportOrdersFilterProvider = NotifierProvider<ReportOrdersFilter, int>(
  ReportOrdersFilter.new,
);

class ReportOrdersFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int value) {
    if (value < 0 || value > 3) throw RangeError.range(value, 0, 3);
    state = value;
  }
}

final reportOrdersSearchProvider = NotifierProvider<ReportOrdersSearch, String>(
  ReportOrdersSearch.new,
);

class ReportOrdersSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}
