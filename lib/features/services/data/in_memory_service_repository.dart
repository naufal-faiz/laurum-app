import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/repositories/service_repository.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';

class InMemoryServiceRepository extends Notifier<List<ServiceItem>> implements ServiceRepository {
  @override
  List<ServiceItem> build() => List.of(serviceFixtures);

  @override
  Future<List<ServiceItem>> getServices({bool includeInactive = false}) async {
    if (includeInactive) return state;
    return state.where((s) => s.isActive && s.deletedAt == null).toList();
  }

  @override
  Future<ServiceItem?> getServiceById(String id) async {
    final match = state.where((s) => s.id == id);
    return match.isEmpty ? null : match.first;
  }

  @override
  Future<void> saveService(ServiceItem service) async {
    final idx = state.indexWhere((s) => s.id == service.id);
    if (idx >= 0) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == idx) service else state[i],
      ];
    } else {
      state = [...state, service];
    }
  }

  @override
  Future<void> deleteService(String id) async {
    state = [
      for (final s in state)
        if (s.id == id)
          ServiceItem(
            id: s.id,
            ownerId: s.ownerId,
            createdAt: s.createdAt,
            name: s.name,
            kind: s.kind,
            price: s.price,
            durationDays: s.durationDays,
            isActive: false,
            deletedAt: DateTime.now(),
          )
        else
          s,
    ];
  }
}

final inMemoryServiceRepositoryProvider =
    NotifierProvider<InMemoryServiceRepository, List<ServiceItem>>(
      InMemoryServiceRepository.new,
    );
