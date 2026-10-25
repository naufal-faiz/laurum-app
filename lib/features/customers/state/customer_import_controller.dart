import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/state/customer_import_data.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/features/transactions/state/add_customer_form.dart';

class CustomerImportState {
  const CustomerImportState({this.query = '', this.selected = const <String>{}});
  final String query;
  final Set<String> selected;
  CustomerImportState copyWith({String? query, Set<String>? selected}) =>
      CustomerImportState(query: query ?? this.query, selected: selected ?? this.selected);
}

class CustomerImportSelection extends Notifier<CustomerImportState> {
  @override
  CustomerImportState build() => const CustomerImportState();

  void setQuery(String value) => state = state.copyWith(query: value);

  void toggle(String key) {
    final next = {...state.selected};
    if (!next.remove(key)) next.add(key);
    state = state.copyWith(selected: next);
  }

  void selectAll(Iterable<String> keys) => state = state.copyWith(selected: keys.toSet());

  Future<int> save(ContactImportData data) async {
    final chosen = data.rows
        .where((row) => !row.exists && state.selected.contains(row.key))
        .toList();
    if (chosen.isEmpty) return 0;
    final repository = ref.read(customerRepositoryProvider);
    final at = ref.read(businessClockProvider)();
    final owner = ref.read(authServiceProvider).currentUserId ?? 'owner';
    var sequence = (await repository.getCustomers(includeInactive: true)).length;
    var saved = 0;
    for (final row in chosen) {
      sequence++;
      try {
        await repository.saveCustomer(
          Customer(
            id: 'cust-new-$sequence',
            ownerId: owner,
            createdAt: at,
            name: row.contact.name,
            phone: normalizePhone(row.contact.phone),
          ),
        );
        saved++;
      } on StateError {
        continue;
      }
    }
    state = const CustomerImportState();
    return saved;
  }
}

final customerImportSelectionProvider =
    NotifierProvider.autoDispose<CustomerImportSelection, CustomerImportState>(
      CustomerImportSelection.new,
    );
