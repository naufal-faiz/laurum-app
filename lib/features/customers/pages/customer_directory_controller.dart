import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerDirectoryFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int value) => state = value;
}

class CustomerDirectorySearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final customerDirectoryFilterProvider = NotifierProvider<CustomerDirectoryFilter, int>(
  CustomerDirectoryFilter.new,
);
final customerDirectorySearchProvider = NotifierProvider<CustomerDirectorySearch, String>(
  CustomerDirectorySearch.new,
);
