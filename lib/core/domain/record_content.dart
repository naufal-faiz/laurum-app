import 'package:laurum/core/domain/domain_record.dart';

// DomainRecord.props starts with id/owner/createdAt/updatedAt/syncState.
// Retry identity includes every business field and excludes only sync metadata.
bool sameRecordContent(DomainRecord a, DomainRecord b) {
  if (a.runtimeType != b.runtimeType) return false;
  final left = a.props, right = b.props;
  if (left.length != right.length) return false;
  for (var i = 0; i < left.length; i++) {
    if (i != 3 && i != 4 && left[i] != right[i]) return false;
  }
  return true;
}
