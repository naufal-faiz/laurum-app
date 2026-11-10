import 'package:flutter_riverpod/flutter_riverpod.dart';

// Production has no accuracy metric. Only the dummy entry overrides this map.
final proposalDemoAccuracyProvider = Provider<Map<String, int>>((ref) => const {});
