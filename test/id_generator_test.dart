import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/services/id_generator_provider.dart';

import 'fake_id_generator.dart';

void main() {
  test('provider can supply deterministic UUIDs to isolated tests', () {
    final scope = ProviderContainer(
      overrides: [
        idGeneratorProvider.overrideWithValue(FakeIdGenerator()),
      ],
    );
    addTearDown(scope.dispose);
    final generator = scope.read(idGeneratorProvider);
    expect(generator.newId(), '00000000-0000-4000-8000-000000000001');
    expect(generator.newId(), '00000000-0000-4000-8000-000000000002');
  });
  const ids = IdGenerator();
  test('new rows use distinct UUID v4 values', () {
    final values = List.generate(100, (_) => ids.newId());
    expect(values.toSet(), hasLength(100));
    for (final id in values) {
      expect(
        id,
        matches(RegExp(r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$')),
      );
    }
  });
  test('retry IDs are UUID v5 and scoped to both parent and label', () {
    final id = ids.derived('prop-001', 'order');
    expect(id, ids.derived('prop-001', 'order'));
    expect(id[14], '5');
    expect(id, isNot(ids.derived('prop-002', 'order')));
    expect(id, isNot(ids.derived('prop-001', 'customer')));
    expect(ids.derived(id, 'payment'), isNot(id));
  });
}
