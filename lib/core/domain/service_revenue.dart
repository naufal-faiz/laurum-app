import 'package:equatable/equatable.dart';

class ServiceRevenue extends Equatable {
  const ServiceRevenue({
    required this.serviceId,
    required this.serviceName,
    required this.unit,
    required this.qtyMilli,
    required this.revenue,
  });
  final String serviceId, serviceName, unit;
  final int qtyMilli, revenue;
  @override
  List<Object?> get props => [serviceId, serviceName, unit, qtyMilli, revenue];
}
