import 'package:laurum/core/domain/customer.dart';

abstract class CustomerRepository {
  // Optional prefix search; display text remains unchanged.
  Future<List<Customer>> getCustomers({bool includeInactive = false, String query = ''});
  Future<Customer?> getCustomerById(String id);
  Future<void> saveCustomer(Customer customer);
  Future<void> deleteCustomer(String id);
}
