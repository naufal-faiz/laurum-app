import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/order_number_generator.dart';
import 'package:laurum/core/domain/repositories/local_settings_repository.dart';
import 'package:laurum/core/services/in_memory_local_settings_repository.dart';

final localSettingsRepositoryProvider = Provider<LocalSettingsRepository>(
  (ref) => InMemoryLocalSettingsRepository(),
);
final orderNumberGeneratorProvider = Provider<OrderNumberGenerator>(
  (ref) => OrderNumberGenerator(settings: ref.read(localSettingsRepositoryProvider)),
);
