import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/account_storage.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/demo_fixture_id.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:path_provider/path_provider.dart';

import 'report_benchmark_seed.dart';

// Separate temporary DB; never replace the user's business/account database.
Future<void> main() async {
  final startup = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  final base = await getTemporaryDirectory();
  final folder = await Directory('${base.path}/laurum-b1f-benchmark').create(recursive: true);
  final owner = demoFixtureId('laurum-benchmark', 'owner');
  final file = File('${folder.path}/laurum_$owner.db');
  final seededNow = !await file.exists();
  if (seededNow) {
    final db = AppDatabase(NativeDatabase(file));
    await seedReportBenchmark(db, ownerId: owner);
    // Realistic queue: 12 active, 4988 archived; all 5000 orders remain in SQLite.
    await db.customStatement(
      "UPDATE orders SET status='selesai' WHERE order_no NOT IN (SELECT order_no FROM orders ORDER BY order_no LIMIT 12)",
    );
    await db.close();
    startup.reset(); // First run prepares the dataset; use subsequent cold starts for target.
  }
  final manager = AccountStorage(directory: () async => folder);
  final container = ProviderContainer(
    overrides: [
      ...driftRepositoryOverrides(auth: FakeAuthService(userId: owner)),
      accountStorageProvider.overrideWithValue(manager),
    ],
  );
  final router = createAppRouter(container: container);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: LaurumApp(router: router),
    ),
  );
  await container.read(accountStoreProvider.future);
  final queue = await container.read(antreanDataProvider.future);
  await WidgetsBinding.instance.endOfFrame;
  debugPrint(
    'LAURUM_B1F ${jsonEncode({
      'seeded_now': seededNow,
      'orders': 5000,
      'active_orders': queue.orders.length,
      'main_to_queue_frame_ms': startup.elapsedMicroseconds / 1000,
      'ready_epoch_ms': DateTime.now().millisecondsSinceEpoch,
    })}',
  );
  final reads = <double>[];
  for (var i = 0; i < 30; i++) {
    container.invalidate(antreanDataProvider);
    final timer = Stopwatch()..start();
    await container.read(antreanDataProvider.future);
    reads.add(timer.elapsedMicroseconds / 1000);
  }
  reads.sort();
  debugPrint(
    'LAURUM_B1F ${jsonEncode({
      'samples': 30,
      'queue_read_median_ms': reads[14],
      'queue_read_p95_ms': reads[28],
      'platform': Platform.operatingSystem,
    })}',
  );
}
