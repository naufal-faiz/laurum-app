import 'package:flutter_riverpod/flutter_riverpod.dart';

// Historical demo summaries disappear with deleted local account data.
class DummyHistory extends Notifier<bool> {
  @override
  bool build() => true;
  void clear() => state = false;
}

final dummyHistoryProvider = NotifierProvider<DummyHistory, bool>(DummyHistory.new);
