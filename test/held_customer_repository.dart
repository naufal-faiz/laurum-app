import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';

class HeldCustomerRepository extends DriftCustomerRepository {
  HeldCustomerRepository(super.db, super.ownerId, super.writer, {required this.waitForReads});
  final Future<void> Function() waitForReads;
  @override
  Future<Customer?> getCustomerById(String id) async {
    await waitForReads();
    return super.getCustomerById(id);
  }

  @override
  Future<List<Customer>> getCustomers({bool includeInactive = false, String query = ''}) async {
    await waitForReads();
    return super.getCustomers(includeInactive: includeInactive, query: query);
  }
}
