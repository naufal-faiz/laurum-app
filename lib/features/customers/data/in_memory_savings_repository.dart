import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/repositories/savings_repository.dart';
import 'package:laurum/core/domain/savings_entry.dart';
import 'package:laurum/core/domain/savings_rules.dart';
import 'package:laurum/core/services/transactional_memory.dart';
import 'package:laurum/features/customers/data/savings_entry_content.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/customers/data/savings_history.dart';

class InMemorySavingsRepository extends Notifier<List<SavingsEntry>>
    with TransactionalMemory<List<SavingsEntry>>
    implements SavingsRepository {
  InMemorySavingsRepository() : _empty = false;
  InMemorySavingsRepository.empty() : _empty = true;
  final bool _empty;
  void clearLocalData() => state = const [];
  @override
  List<SavingsEntry> build() {
    return List.unmodifiable(_empty ? [] : savingsFixtures);
  }

  @override
  Future<List<SavingsEntry>> getEntriesByCustomerId(String customerId) async {
    return savingsHistory(state.where((e) => e.customerId == customerId));
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
    final existing = state.where((e) => e.id == entry.id);
    if (existing.isNotEmpty) {
      if (!sameSavingsContent(existing.single, entry)) {
        throw StateError('Savings entries are immutable');
      }
      return;
    }
    if (entry.kind != SavingsKind.penyesuaian && entry.amount <= 0) {
      throw ArgumentError('Deposit or withdrawal must be positive');
    }
    if (savingsBalance([...state, entry], customerId: entry.customerId) < 0) {
      throw StateError('Insufficient savings balance');
    }
    state = List.unmodifiable([...state, entry]);
  }
}

final inMemorySavingsRepositoryProvider =
    NotifierProvider<InMemorySavingsRepository, List<SavingsEntry>>(
      InMemorySavingsRepository.new,
    );
