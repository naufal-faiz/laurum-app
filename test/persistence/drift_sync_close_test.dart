import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/persistence/account_storage.dart';

void main() {
  test('logout closes database even while an offscreen sync listener is paused', () async {
    final folder = await Directory.systemTemp.createTemp('laurum-paused-sync-');
    final storage = AccountStorage(directory: () async => folder);
    final store = (await storage.activate('account'))!;
    final paused = store.sync.statusStream.listen((_) {})..pause();
    final pausedChanges = store.changes.stream.listen((_) {})..pause();
    try {
      await storage.activate(null).timeout(const Duration(seconds: 3));
    } finally {
      await paused.cancel();
      await pausedChanges.cancel();
      await storage.close();
      await folder.delete(recursive: true);
    }
  });
}
