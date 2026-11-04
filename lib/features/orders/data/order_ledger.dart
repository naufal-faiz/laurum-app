import 'package:laurum/core/domain/domain_record.dart';
import 'package:laurum/core/domain/record_content.dart';

List<T> appendLedger<T extends DomainRecord>(Iterable<T> old, Iterable<T> added) {
  final byId = {for (final row in old) row.id: row};
  for (final row in added) {
    final existing = byId[row.id];
    if (existing != null && !sameRecordContent(existing, row)) {
      throw StateError('Ledger is immutable');
    }
    byId.putIfAbsent(row.id, () => row);
  }
  return List.unmodifiable(byId.values);
}
