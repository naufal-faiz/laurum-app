import 'package:laurum/core/domain/id_generator.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/sql_timestamp.dart';

Future<({String owner, ReportRange range})> seedReportBenchmark(AppDatabase db) async {
  const ids = IdGenerator();
  final owner = ids.newId(), customer = ids.newId(), service = ids.newId(), category = ids.newId();
  final day = DateTime(2026, 9);
  final created = day.toIso8601String();
  final orders = List.generate(5000, (_) => ids.newId());
  await db.customStatement('INSERT INTO customers(id,owner_id,created_at,name) VALUES(?,?,?,?)', [
    customer,
    owner,
    created,
    'Benchmark',
  ]);
  await db.customStatement(
    "INSERT INTO services(id,owner_id,created_at,name,kind,price,duration_days) VALUES(?,?,?,?,'satuan',1000,1)",
    [service, owner, created, 'Layanan uji'],
  );
  await db.customStatement(
    'INSERT INTO expense_categories(id,owner_id,created_at,name) VALUES(?,?,?,?)',
    [category, owner, created, 'Operasional'],
  );
  await db.batch((b) {
    for (var i = 0; i < orders.length; i++) {
      final at = day.add(Duration(days: i % 60, hours: 12));
      b.customStatement(
        '''INSERT INTO orders(id,owner_id,created_at,order_no,customer_id,
        status,source,entered_at,estimated_at,subtotal,total)
        VALUES(?,?,?,?,?,'diproses','kasir',?,?,1000,1000)''',
        [
          orders[i],
          owner,
          created,
          'A-${(i + 1).toString().padLeft(4, '0')}',
          customer,
          sqlTimestamp(at),
          at.toIso8601String(),
        ],
      );
      b.customStatement(
        '''INSERT INTO order_items(id,owner_id,created_at,order_id,service_id,
        service_name,unit,qty_milli,unit_price,line_total) VALUES(?,?,?,?,?,?,'pcs',1000,1000,1000)''',
        [ids.newId(), owner, created, orders[i], service, 'Layanan uji'],
      );
    }
    for (var i = 0; i < 8000; i++) {
      b.customStatement(
        '''INSERT INTO payments(id,owner_id,created_at,order_id,method,amount,received,paid_at)
        VALUES(?,?,?,?,'tunai',100,100,?)''',
        [
          ids.newId(),
          owner,
          created,
          orders[i % 5000],
          sqlTimestamp(day.add(Duration(days: (i % 5000) % 60, hours: 14))),
        ],
      );
    }
    for (var i = 0; i < 100; i++) {
      b.customStatement(
        '''INSERT INTO expenses(id,owner_id,created_at,category_id,amount,spent_at)
        VALUES(?,?,?,?,100,?)''',
        [ids.newId(), owner, created, category, sqlTimestamp(day.add(Duration(days: i % 60)))],
      );
    }
    for (var i = 0; i < 20; i++) {
      final at = day.add(Duration(days: i));
      b.customStatement(
        '''INSERT INTO savings_entries(id,owner_id,created_at,created_key,
        customer_id,kind,amount,method) VALUES(?,?,?,?,?,'setor',100,'tunai')''',
        [ids.newId(), owner, at.toIso8601String(), sqlTimestamp(at), customer],
      );
    }
  });
  await db.customStatement('ANALYZE');
  return (owner: owner, range: ReportRange(DateTime(2026, 10), DateTime(2026, 11)));
}
