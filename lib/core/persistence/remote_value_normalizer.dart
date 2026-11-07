import 'package:laurum/core/persistence/sql_timestamp.dart';

const _timestampColumns = {
  'created_at',
  'updated_at',
  'deleted_at',
  'entered_at',
  'estimated_at',
  'paid_at',
  'occurred_at',
  'spent_at',
  'last_seen_at',
  'valid_until',
};

Object? normalizeRemoteValue(String name, String type, Object? value) {
  if (value == null) return null;
  if (value is bool) return value ? 1 : 0;
  if (_timestampColumns.contains(name) && value is String) {
    return sqlTimestamp(DateTime.parse(value).toUtc());
  }
  if (value is num) {
    if (type != 'INTEGER') return value;
    if (value is double && (!value.isFinite || value != value.roundToDouble())) {
      throw FormatException('Non-integer value for $name');
    }
    return value.toInt();
  }
  if (value is String) return value;
  throw FormatException('Unsupported remote value for $name');
}
