import 'dart:io';

import 'package:laurum/core/persistence/account_local_data_service.dart';
import 'package:laurum/core/persistence/account_store.dart';
import 'package:laurum/core/persistence/app_database_factory.dart';
import 'package:laurum/core/persistence/drift_local_data_service.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:path_provider/path_provider.dart';

class AccountStorage {
  AccountStorage({
    Future<Directory> Function()? directory,
    this.prepare,
    this.participants,
    this.clock,
  }) : directory = directory ?? getApplicationSupportDirectory;
  final Future<Directory> Function() directory;
  final Future<void> Function(AccountStore)? prepare;
  final Iterable<TransactionParticipant> Function()? participants;
  final DateTime Function()? clock;
  AccountStore? _store;
  AppDatabaseFactory? _factory;
  Future<void> _tail = Future.value();
  Future<T> _serial<T>(Future<T> Function() body) {
    final result = _tail.then((_) => body());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  Future<AccountStore?> activate(String? ownerId) => _serial(() async {
    if (_store?.ownerId == ownerId) return _store;
    await _close();
    if (ownerId == null) return null;
    final factory = AppDatabaseFactory(ownerId, directory: directory);
    final db = await factory.open();
    AccountStore? opening;
    try {
      await db.customSelect('SELECT 1').get(); // Force open/migration before displaying routes.
      final store = opening = AccountStore(
        db,
        ownerId,
        directory: directory,
        participants: participants,
        clock: clock,
      );
      await prepare?.call(store);
      await store.start();
      store.localData = AccountLocalDataService(
        DriftLocalDataService(db, ownerId, store.runner),
        () => _serial(() async {
          if (!identical(store, _store)) throw StateError('Account is no longer active');
          await _close();
          await factory.delete();
          final base = await directory();
          final photos = Directory('${base.path}/expense_photos/$ownerId');
          if (await photos.exists()) {
            final root = await base.resolveSymbolicLinks();
            final resolved = await photos.resolveSymbolicLinks();
            if (!resolved.startsWith(
              '$root${Platform.pathSeparator}expense_photos${Platform.pathSeparator}',
            )) {
              throw StateError('Photo folder is outside account storage');
            }
            await photos.delete(recursive: true);
          }
        }),
      );
      _factory = factory;
      return _store = store;
    } catch (_) {
      await opening?.dispose();
      await factory.close();
      rethrow;
    }
  });
  Future<void> _close() async {
    final store = _store, factory = _factory;
    _store = null;
    _factory = null;
    try {
      await store?.dispose();
    } finally {
      await factory?.close();
    }
  }

  Future<void> close() => _serial(_close);
}
