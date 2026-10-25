import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/services/repository_providers.dart';

final serviceDirectoryProvider = FutureProvider<List<ServiceItem>>(
  (ref) => ref.watch(serviceRepositoryProvider).getServices(includeInactive: true),
);

final serviceDirectorySearchProvider = NotifierProvider<ServiceDirectorySearch, String>(
  ServiceDirectorySearch.new,
);

class ServiceDirectorySearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}
