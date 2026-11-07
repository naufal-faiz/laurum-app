import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/sync/canonical_json.dart';
import 'package:laurum/core/sync/sync_change.dart';
import 'package:laurum/core/sync/sync_hash.dart';

void main() {
  const change = SyncChange(
    changeId: '10000000-0000-4000-8000-000000000001',
    table: 'customers',
    rowId: '20000000-0000-4000-8000-000000000001',
    op: 'upsert',
    payload: {'phone': null, 'name': 'Ratna'},
  );
  test('canonical JSON sorts keys and keeps array order', () {
    expect(
      canonicalJson({
        'b': 1,
        'a': [
          2,
          {'d': true, 'c': null},
        ],
      }),
      '{"a":[2,{"c":null,"d":true}],"b":1}',
    );
  });
  test('group hash matches the server contract vector', () {
    expect(
      syncHash([change.toJson()]),
      '2249217f430921a189baaff722d273b4d0ca9ed9c661e1704bf92965d3dc3962',
    );
  });
  test('non-integer numbers are rejected instead of silently rounded', () {
    expect(() => canonicalJson(1.5), throwsFormatException);
  });
}
