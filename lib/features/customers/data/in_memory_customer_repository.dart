import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/repositories/customer_repository.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';

class InMemoryCustomerRepository extends Notifier<List<Customer>> implements CustomerRepository {
  @override
  List<Customer> build() => List.of(customerFixtures);

  @override
  Future<List<Customer>> getCustomers({bool includeInactive = false}) async {
    if (includeInactive) return state;
    return state.where((c) => c.isActive && c.deletedAt == null).toList();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    final match = state.where((c) => c.id == id);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<void> saveCustomer(Customer customer) async {
    final idx = state.indexWhere((c) => c.id == customer.id);
    if (idx >= 0) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == idx) customer else state[i],
      ];
    } else {
      state = [...state, customer];
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    state = [
      for (final c in state)
        if (c.id == id)
          Customer(
            id: c.id,
            ownerId: c.ownerId,
            createdAt: c.createdAt,
            name: c.name,
            phone: c.phone,
            address: c.address,
            notes: c.notes,
            isActive: false,
            deletedAt: DateTime.now(),
          )
        else
          c,
    ];
  }
}

final inMemoryCustomerRepositoryProvider =
    NotifierProvider<InMemoryCustomerRepository, List<Customer>>(
      InMemoryCustomerRepository.new,
    );
