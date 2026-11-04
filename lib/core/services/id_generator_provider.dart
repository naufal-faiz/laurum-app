import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/domain/id_generator.dart';

final idGeneratorProvider = Provider<IdGenerator>((ref) => const IdGenerator());
