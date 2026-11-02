import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/transaction_runner.dart';

mixin TransactionalMemory<T> on Notifier<T> implements TransactionParticipant {
  @override
  void Function() checkpoint() {
    final saved = state;
    return () => state = saved;
  }
}
