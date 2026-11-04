import 'package:drift/drift.dart';
import 'package:laurum/core/domain/customer_search.dart';
import 'package:laurum/core/persistence/app_database.dart';

({String sql, List<Variable<Object>> variables}) customerSelect(
  String ownerId, {
  bool includeInactive = false,
  String query = '',
}) {
  final active = includeInactive ? '' : 'AND is_active = 1';
  final base =
      'SELECT rowid AS _position, * FROM customers '
      'WHERE owner_id = ? AND deleted_at IS NULL $active';
  final key = customerNameKey(query), phone = customerPhonePrefix(query);
  final variables = <Variable<Object>>[Variable<String>(ownerId)];
  if (key.isEmpty) return (sql: '$base ORDER BY _position', variables: variables);
  String pattern(String value) =>
      '${value.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_')}%';
  var sql = "$base AND name_key LIKE ? ESCAPE '\\'";
  variables.add(Variable<String>(pattern(key)));
  if (phone.isNotEmpty) {
    sql += " UNION $base AND phone_key LIKE ? ESCAPE '\\'";
    variables.addAll([Variable<String>(ownerId), Variable<String>(pattern(phone))]);
  }
  return (sql: '$sql ORDER BY _position', variables: variables);
}

Future<List<CustomerRow>> readCustomers(
  AppDatabase db,
  String ownerId, {
  bool includeInactive = false,
  String query = '',
}) async {
  final request = customerSelect(ownerId, includeInactive: includeInactive, query: query);
  final rows = await db
      .customSelect(request.sql, variables: request.variables, readsFrom: {db.customerRecords})
      .get();
  return [for (final row in rows) db.customerRecords.map(row.data)];
}
