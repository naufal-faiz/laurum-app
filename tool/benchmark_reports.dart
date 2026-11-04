import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/features/reports/data/drift_report_repository.dart';

import 'report_benchmark_seed.dart';

Future<void> main() async {
  final db = AppDatabase(NativeDatabase.memory());
  try {
    final seed = await seedReportBenchmark(db);
    final repo = DriftReportRepository(db, seed.owner);
    final result = <String, Object>{
      'platform': Platform.operatingSystem,
      'storage': 'memory',
      'orders': 5000,
      'payments': 8000,
      'items': 5000,
      'expenses': 100,
      'savings': 20,
      'range': 'October 2026',
      'warmups': 5,
      'samples': 30,
      'gating': false,
    };
    final tasks = <String, Future<Object> Function()>{
      'totals': () => repo.getReport(seed.range),
      'daily': () => repo.getDailyRevenue(seed.range),
      'services': () => repo.getTopServices(seed.range),
    };
    for (final entry in tasks.entries) {
      for (var i = 0; i < 5; i++) {
        await entry.value();
      }
      final values = <double>[];
      for (var i = 0; i < 30; i++) {
        final clock = Stopwatch()..start();
        await entry.value();
        values.add(clock.elapsedMicroseconds / 1000);
      }
      values.sort();
      result[entry.key] = {'median_ms': values[14], 'p95_ms': values[28]};
    }
    final totals = await repo.getReport(seed.range);
    result['revenue'] = totals.revenue;
    result['transaction_count'] = totals.transactionCount;
    stdout.writeln(jsonEncode(result));
  } finally {
    await db.close();
  }
}
