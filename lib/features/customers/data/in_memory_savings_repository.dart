import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';

class InMemorySavingsRepository extends Notifier<List<SavingsEntry>> implements SavingsRepository {
  @override
  List<SavingsEntry> build() => List.of(savingsFixtures);

  @override
  Future<List<SavingsEntry>> getEntriesByCustomerId(String customerId) async {
    return state.where((e) => e.customerId == customerId).toList();
  }

  @override
  Future<List<SavingsEntry>> getAllEntries() async => List.unmodifiable(state);

  @override
  Future<int> getBalance(String customerId) async {
    final entries = await getEntriesByCustomerId(customerId);
    return savingsBalance(entries);
  }

  @override
  Future<void> addEntry(SavingsEntry entry) async {
    state = [...state, entry];
  }
}

final inMemorySavingsRepositoryProvider =
    NotifierProvider<InMemorySavingsRepository, List<SavingsEntry>>(
      InMemorySavingsRepository.new,
    );
