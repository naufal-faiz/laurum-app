import 'package:laurum/core/domain/savings_entry.dart';

List<SavingsEntry> savingsHistory(Iterable<SavingsEntry> values) {
  final indexed = values.indexed.toList()
    ..sort((a, b) {
      final date = b.$2.createdAt.compareTo(a.$2.createdAt);
      return date != 0 ? date : a.$1.compareTo(b.$1);
    });
  return List.unmodifiable(indexed.map((r) => r.$2));
}
