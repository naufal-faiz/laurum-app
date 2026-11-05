import 'package:flutter_riverpod/flutter_riverpod.dart';

// Production summaries use the ledger. Only the memory demo injects old summaries.
final customerHistoryOffsetsProvider = Provider<Map<String, ({int orderCount, int revenue})>>(
  (ref) => const {},
);
