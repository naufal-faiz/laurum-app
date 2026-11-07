import 'dart:convert';

// Mirrors private.canonical_json on the server: sorted object keys, ordered arrays,
// integer numbers only, JSON string escaping.
String canonicalJson(Object? value) {
  if (value == null) return 'null';
  if (value is bool) return value.toString();
  if (value is int) return value.toString();
  if (value is String) return jsonEncode(value);
  if (value is List) return '[${value.map(canonicalJson).join(',')}]';
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return '{${keys.map((key) => '${jsonEncode(key)}:${canonicalJson(value[key])}').join(',')}}';
  }
  throw FormatException('Unsupported canonical JSON value: ${value.runtimeType}');
}
