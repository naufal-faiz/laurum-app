import 'package:laurum/core/domain/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers({bool includeInactive = false});
  Future<Customer?> getCustomerById(String id);
  Future<void> saveCustomer(Customer customer);
  Future<void> deleteCustomer(String id);
}
