abstract interface class TransactionRunner {
  Future<T> run<T>(Future<T> Function() body);
}

// Internal capability for immutable in-memory stores, not repository API.
abstract interface class TransactionParticipant {
  void Function() checkpoint();
}
