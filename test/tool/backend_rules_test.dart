import 'package:flutter_test/flutter_test.dart';

import '../../tool/backend_rules.dart';

void main() {
  test('persistence imports confined to data and dedicated core layers', () {
    for (final package in persistencePackages) {
      final code = "import 'package:$package/example.dart';";
      for (final path in [
        'lib/features/orders/state/x.dart',
        'lib/shared/widgets/x.dart',
        'lib/core/services/x.dart',
        'lib/features/orders/pages/x.dart',
      ]) {
        expect(checkBackendFile(path, code), isNotEmpty, reason: '$path $package');
      }
      for (final path in [
        'lib/core/persistence/x.dart',
        'lib/core/sync/x.dart',
        'lib/features/orders/data/x.dart',
      ]) {
        expect(checkBackendFile(path, code), isEmpty);
      }
    }
  });
  test('shared_preferences forbidden in imports, exports and pubspec', () {
    expect(
      checkBackendFile(
        'lib/core/persistence/x.dart',
        "export 'package:shared_preferences/shared_preferences.dart';",
      ),
      isNotEmpty,
    );
    expect(checkBackendPubspec('dependencies:\n  shared_preferences: any'), isNotEmpty);
    expect(checkBackendPubspec('dependencies:\n  uuid: any'), isEmpty);
  });
  test('text/count/timestamp row IDs rejected; generator and copied IDs allowed', () {
    for (final code in [
      r"id: 'ord-$number',",
      r"final paymentId = '$id-payment-${rows.length + 1}';",
      r"id: 'exp-${DateTime.now().microsecondsSinceEpoch}',",
      r'id: "cust-$sequence",',
      "final rowId =\n 'ord-' + count.toString();",
      'id: DateTime.now().microsecondsSinceEpoch.toString(),',
      'final paymentId = payments.length.toString();',
    ]) {
      expect(checkBackendFile('lib/features/orders/state/save.dart', code), isNotEmpty);
    }
    for (final code in [
      'id: ids.newId(),',
      "id: ids.derived(p.id, 'order'),",
      'id: existing.id,',
      r"orderNo: '$device-$sequence',",
    ]) {
      expect(checkBackendFile('lib/features/orders/state/save.dart', code), isEmpty);
    }
    expect(
      checkBackendFile('lib/features/orders/data/order_fixtures.dart', r"id: 'ord-$number',"),
      isEmpty,
    );
  });
}
