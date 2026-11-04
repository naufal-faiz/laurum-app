import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';

// Non-gating read benchmark; bulk SQL deliberately excludes repository write costs.
Future<void> main() async {
  final db = AppDatabase(NativeDatabase.memory());
  const ids = IdGenerator();
  final owner = ids.newId(), customer = ids.newId();
  final day = DateTime(2026, 9);
  final orderIds = List.generate(5000, (_) => ids.newId());
  try {
    await db.customStatement(
      'INSERT INTO customers (id, owner_id, created_at, name) VALUES (?, ?, ?, ?)',
      [customer, owner, day.toIso8601String(), 'Benchmark'],
    );
    await db.batch((batch) {
      for (var i = 0; i < orderIds.length; i++) {
        final at = day.add(Duration(days: i % 60, hours: 12));
        batch.customStatement(
          '''INSERT INTO orders (id, owner_id, created_at, order_no,
          customer_id, status, source, entered_at, estimated_at, subtotal, total)
          VALUES (?, ?, ?, ?, ?, 'diproses', 'kasir', ?, ?, 100, 100)''',
          [
            orderIds[i],
            owner,
            day.toIso8601String(),
            'A-${(i + 1).toString().padLeft(4, '0')}',
            customer,
            sqlTimestamp(at),
            at.toIso8601String(),
          ],
        );
      }
      for (var i = 0; i < 8000; i++) {
        batch.customStatement(
          '''INSERT INTO payments (id, owner_id, created_at, order_id,
          method, amount, received, paid_at) VALUES (?, ?, ?, ?, 'tunai', 10, 10, ?)''',
          [
            ids.newId(),
            owner,
            day.toIso8601String(),
            orderIds[i % orderIds.length],
            sqlTimestamp(day),
          ],
        );
      }
    });
    await db.customStatement('ANALYZE');
    final repo = DriftOrderRepository(db, owner, OutboxWriter(db, DriftTransactionRunner(db)));
    final range = ReportRange(day.add(const Duration(days: 20)), day.add(const Duration(days: 27)));
    for (var i = 0; i < 5; i++) {
      await repo.getOrdersInRange(range);
    }
    final samples = <double>[];
    var rows = 0;
    for (var i = 0; i < 100; i++) {
      final watch = Stopwatch()..start();
      rows = (await repo.getOrdersInRange(range)).length;
      samples.add(watch.elapsedMicroseconds / 1000);
    }
    samples.sort();
    stdout.writeln(
      jsonEncode({
        'platform': Platform.operatingSystem,
        'orders': 5000,
        'payments': 8000,
        'range_days': 7,
        'returned_rows': rows,
        'warmups': 5,
        'samples': samples.length,
        'median_ms': samples[49],
        'p95_ms': samples[94],
        'target_ms': 100,
        'gating': false,
      }),
    );
  } finally {
    await db.close();
  }
}
