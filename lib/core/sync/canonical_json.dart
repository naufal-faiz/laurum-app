import 'dart:convert';

// Mirrors private.canonical_json on the server: sorted object keys, ordered arrays,
// integer numbers only, JSON string escaping.
String canonicalJson(Object? value) {
  if (value == null) return 'null';
  if (value is bool) return value.toString();
  if (value is int) return value.toString();
  // Pecahan hanya untuk kolom seperti ai_proposals.confidence (numeric 0..1).
  // Ditulis apa adanya (tanpa pembulatan) agar sama dengan teks jsonb di server:
  // 0.9 -> "0.9". Nilai yang tidak punya bentuk desimal stabil ditolak.
  if (value is double) {
    if (!value.isFinite) throw FormatException('Non-finite number: $value');
    final text = value.toString();
    if (text.contains('e') || text.contains('E')) {
      throw FormatException('Unsupported number format: $value');
    }
    return text;
  }
  if (value is String) return jsonEncode(value);
  if (value is List) return '[${value.map(canonicalJson).join(',')}]';
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return '{${keys.map((key) => '${jsonEncode(key)}:${canonicalJson(value[key])}').join(',')}}';
  }
  throw FormatException('Unsupported canonical JSON value: ${value.runtimeType}');
}
