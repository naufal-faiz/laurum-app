import 'dart:io';

import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:path_provider/path_provider.dart';

class ExpensePhotoStore {
  ExpensePhotoStore(
    this.ownerId, {
    Future<Directory> Function()? directory,
    this.ids = const IdGenerator(),
  }) : directory = directory ?? getApplicationSupportDirectory {
    if (!RegExp(r'^[a-zA-Z0-9_-]{1,128}$').hasMatch(ownerId)) throw ArgumentError('Invalid owner');
  }
  final String ownerId;
  final Future<Directory> Function() directory;
  final IdGenerator ids;
  Future<String?> stage(String? path, DriftTransactionRunner runner) async {
    if (path == null) return null;
    final source = File(path);
    if (!await source.exists()) throw const FileSystemException('Selected photo is unavailable');
    final base = await directory();
    final folder = await Directory('${base.path}/expense_photos/$ownerId').create(recursive: true);
    final root = await folder.resolveSymbolicLinks();
    final input = await source.resolveSymbolicLinks();
    if (input.startsWith('$root${Platform.pathSeparator}')) return input;
    final extension = RegExp(r'\.[a-zA-Z0-9]{1,8}$').firstMatch(input)?.group(0) ?? '.img';
    final target = File('$root${Platform.pathSeparator}${ids.newId()}$extension');
    runner.onRollback(() async {
      if (await target.exists()) await target.delete();
    });
    await source.copy(target.path);
    return target.path;
  }
}
