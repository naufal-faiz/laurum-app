import 'package:laurum/core/domain/service_item.dart';

abstract class ServiceRepository {
  Future<List<ServiceItem>> getServices({bool includeInactive = false});
  Future<ServiceItem?> getServiceById(String id);
  Future<void> saveService(ServiceItem service);
  Future<void> deleteService(String id);
}
