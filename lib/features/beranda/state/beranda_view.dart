import 'package:laurum/core/domain/order.dart';
import 'package:laurum/core/domain/order_item.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/features/beranda/state/beranda_services.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';

export 'beranda_services.dart' show BerandaStageTone;

/// View data of `LAURUM · Beranda`, derived only from existing providers.
class BerandaView {
  const BerandaView({
    required this.businessName,
    required this.total,
    required this.updatedLabel,
    required this.stages,
    required this.savedCustomers,
    required this.newCustomers,
    required this.initials,
    required this.revenue,
    required this.daily,
    required this.frequent,
  });

  factory BerandaView.from({
    required String businessName,
    required List<Order> orders,
    required List<CustomerDirectoryRow> customers,
    required int revenue,
    required List<int?> daily,
    required DateTime now,
    Map<String, List<OrderItem>> items = const {},
  }) {
    final latest = orders.isEmpty
        ? null
        : orders
              .map((order) => order.updatedAt ?? order.createdAt)
              .reduce(
                (a, b) => a.isAfter(b) ? a : b,
              );
    final frequent = [...customers.where((row) => row.orderCount > 0)]
      ..sort((a, b) => b.orderCount.compareTo(a.orderCount));
    final recent = [...customers]
      ..sort((a, b) => b.customer.createdAt.compareTo(a.customer.createdAt));
    return BerandaView(
      businessName: businessName,
      total: orders.length,
      updatedLabel: latest == null ? 'Belum ada antrean' : 'Diperbarui ${Formatters.jam(latest)}',
      stages: berandaServices(orders, items),
      savedCustomers: customers.length,
      newCustomers: customers
          .where(
            (row) =>
                row.customer.createdAt.year == now.year &&
                row.customer.createdAt.month == now.month,
          )
          .length,
      initials: [
        for (final row in recent.take(3)) _initialOf(row.customer.name),
      ],
      revenue: revenue,
      daily: daily,
      frequent: [
        for (final row in frequent.take(3))
          (
            id: row.customer.id,
            name: row.customer.name,
            initials: _initialsOf(row.customer.name),
            detail: '${row.orderCount} kali laundry',
            trailing: '${row.orderCount}×',
          ),
      ],
    );
  }

  final String businessName, updatedLabel;
  final int total, savedCustomers, newCustomers, revenue;
  final List<({String label, int value, BerandaStageTone tone})> stages;
  final List<String> initials;
  final List<int?> daily;
  final List<({String id, String name, String initials, String detail, String trailing})> frequent;
}

String _initialOf(String name) => name.trim().isEmpty ? '' : name.trim()[0].toUpperCase();

String _initialsOf(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .where((word) => word.isNotEmpty)
    .take(2)
    .map((word) => word[0].toUpperCase())
    .join();
