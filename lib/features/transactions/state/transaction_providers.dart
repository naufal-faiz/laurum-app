import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/repository_providers.dart';

final serviceCatalogProvider = FutureProvider<List<ServiceItem>>(
  (ref) => ref.watch(serviceRepositoryProvider).getServices(),
);

final customerCatalogProvider = FutureProvider<List<Customer>>(
  (ref) => ref.watch(customerRepositoryProvider).getCustomers(),
);

final customerBalanceProvider = FutureProvider.family<int, String>(
  (ref, id) => ref.watch(savingsRepositoryProvider).getBalance(id),
);

final serviceSearchProvider = NotifierProvider<ServiceSearch, String>(ServiceSearch.new);

class ServiceSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final customerSearchProvider = NotifierProvider<CustomerSearch, String>(CustomerSearch.new);

class CustomerSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}
