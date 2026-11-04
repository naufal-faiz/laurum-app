// Fixed-width UTC text keeps SQLite's lexical range ordering exact to microseconds.
String sqlTimestamp(DateTime at) {
  final iso = at.toUtc().toIso8601String();
  final dot = iso.indexOf('.');
  return '${iso.substring(0, dot)}.${iso.substring(dot + 1, iso.length - 1).padRight(6, '0')}Z';
}
