import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/customers/state/customer_directory_controller.dart';

class CustomerDirectoryExpansion extends Notifier<bool> {
  @override
  bool build() {
    ref.watch(customerDirectoryFilterProvider);
    ref.watch(customerDirectorySearchProvider);
    return false;
  }

  void showAll() => state = true;
}

final customerDirectoryExpansionProvider = NotifierProvider<CustomerDirectoryExpansion, bool>(
  CustomerDirectoryExpansion.new,
);
