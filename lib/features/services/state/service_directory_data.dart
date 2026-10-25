import 'package:laurum/core/domain/service_item.dart';

List<ServiceItem> visibleServices(List<ServiceItem> all, String query) {
  final keyword = query.trim().toLowerCase();
  final sorted = [...all]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return keyword.isEmpty
      ? sorted
      : sorted.where((s) => s.name.toLowerCase().contains(keyword)).toList();
}

String serviceSummary(List<ServiceItem> all) =>
    'Total ${all.length} layanan (${all.where((s) => s.isActive).length} aktif)';

int nextServiceSortOrder(List<ServiceItem> all) =>
    all.isEmpty ? 1 : all.map((s) => s.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
