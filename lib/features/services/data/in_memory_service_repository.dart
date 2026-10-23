import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';

class InMemoryServiceRepository extends Notifier<List<ServiceItem>> implements ServiceRepository {
  @override
  List<ServiceItem> build() => List.unmodifiable(serviceFixtures);

  @override
  Future<List<ServiceItem>> getServices({bool includeInactive = false}) async {
    return List.unmodifiable(
      state.where((s) => s.deletedAt == null && (includeInactive || s.isActive)),
    );
  }

  @override
  Future<ServiceItem?> getServiceById(String id) async {
    final match = state.where((s) => s.id == id && s.deletedAt == null);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<void> saveService(ServiceItem service) async {
    final idx = state.indexWhere((s) => s.id == service.id);
    if (idx >= 0) {
      state = List.unmodifiable([
        for (var i = 0; i < state.length; i++)
          if (i == idx) service else state[i],
      ]);
    } else {
      state = List.unmodifiable([...state, service]);
    }
  }

  @override
  Future<void> deleteService(String id) async {
    state = List.unmodifiable([
      for (final s in state)
        if (s.id == id && s.deletedAt == null)
          ServiceItem(
            id: s.id,
            ownerId: s.ownerId,
            createdAt: s.createdAt,
            name: s.name,
            kind: s.kind,
            price: s.price,
            durationDays: s.durationDays,
            isActive: false,
            sortOrder: s.sortOrder,
            updatedAt: s.updatedAt,
            deletedAt: DateTime.now(),
          )
        else
          s,
    ]);
  }
}

final inMemoryServiceRepositoryProvider =
    NotifierProvider<InMemoryServiceRepository, List<ServiceItem>>(
      InMemoryServiceRepository.new,
    );
