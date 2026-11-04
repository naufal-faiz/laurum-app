import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/customers/data/customer_queries.dart';

void main() {
  test('prefix query uses name and phone range indexes', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final query = customerSelect('owner', query: '0812');
    final rows = await db
        .customSelect('EXPLAIN QUERY PLAN ${query.sql}', variables: query.variables)
        .get();
    final detail = rows.map((r) => r.read<String>('detail')).join('\n');
    expect(detail, contains('customers_name_prefix'));
    expect(detail, contains('customers_phone_prefix'));
    expect(detail, contains('name_key>?'));
    expect(detail, contains('phone_key>?'));
  });
}
