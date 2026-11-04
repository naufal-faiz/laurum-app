import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/repositories/local_settings_repository.dart';

void runLocalSettingsRepositoryContract(FutureOr<LocalSettingsRepository> Function() factory) {
  late LocalSettingsRepository repo;
  setUp(() async => repo = await factory());
  test('missing keys are null and values replace within the same key', () async {
    expect(await repo.getString('printer'), isNull);
    expect(await repo.getInt('counter'), isNull);
    await repo.setString('printer', 'printer-1');
    await repo.setInt('counter', 142);
    expect(await repo.getString('printer'), 'printer-1');
    expect(await repo.getInt('counter'), 142);
    await repo.setInt('counter', 143);
    expect(await repo.getInt('counter'), 143);
    expect(await repo.getString('printer'), 'printer-1');
  });
  test('key has one type and reading the other type returns null', () async {
    await repo.setString('value', 'A');
    expect(await repo.getInt('value'), isNull);
    await repo.setInt('value', 0);
    expect(await repo.getString('value'), isNull);
    expect(await repo.getInt('value'), 0);
  });
}
