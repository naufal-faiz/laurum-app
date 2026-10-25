import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';

ServiceItem copyService(
  ServiceItem service, {
  String? name,
  ServiceKind? kind,
  int? price,
  int? durationDays,
  bool? isActive,
  DateTime? updatedAt,
}) => ServiceItem(
  id: service.id,
  ownerId: service.ownerId,
  createdAt: service.createdAt,
  name: name ?? service.name,
  kind: kind ?? service.kind,
  price: price ?? service.price,
  durationDays: durationDays ?? service.durationDays,
  isActive: isActive ?? service.isActive,
  sortOrder: service.sortOrder,
  updatedAt: updatedAt ?? service.updatedAt,
  syncState: service.syncState,
  deletedAt: service.deletedAt,
);
