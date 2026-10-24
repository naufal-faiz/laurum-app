import 'package:flutter_riverpod/flutter_riverpod.dart';

final notaFilterProvider = NotifierProvider<NotaFilter, int>(NotaFilter.new);

class NotaFilter extends Notifier<int> {
  @override
  int build() => 0;
  void select(int value) {
    if (value < 0 || value > 4) throw RangeError.range(value, 0, 4);
    state = value;
  }
}

final notaSearchProvider = NotifierProvider<NotaSearch, String>(NotaSearch.new);

class NotaSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}
