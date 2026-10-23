import 'package:laurum/core/domain/savings_entry.dart';

abstract class SavingsRepository {
  Future<List<SavingsEntry>> getEntriesByCustomerId(String customerId);
  Future<List<SavingsEntry>> getAllEntries();
  Future<int> getBalance(String customerId);
  Future<void> addEntry(SavingsEntry entry);
}
