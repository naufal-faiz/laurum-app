import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/transactional_memory.dart';

// Historical demo summaries disappear with deleted local account data.
final dummyHistoryEnabledProvider = Provider<bool>((ref) => true);

class DummyHistory extends Notifier<bool> with TransactionalMemory<bool> {
  @override
  bool build() => ref.watch(dummyHistoryEnabledProvider);
  void clear() => state = false;
}

final dummyHistoryProvider = NotifierProvider<DummyHistory, bool>(DummyHistory.new);
