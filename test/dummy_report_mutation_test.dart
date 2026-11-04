import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/payment.dart';
import 'package:laurum/core/domain/report_range.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/reports/data/report_samples.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer(overrides: dummyRepositoryOverrides));
  tearDown(() => container.dispose());

  test('paying old debt updates cash, position and reconciliation reactively', () async {
    var notifications = 0;
    final sub = container.listen(reportRepositoryProvider, (_, _) => notifications++);
    final reports = container.read(reportRepositoryProvider);
    final before = await reports.getReport(weekRange);
    await container
        .read(orderRepositoryProvider)
        .addPayment(
          Payment(
            id: 'settle-142',
            ownerId: dummyOwnerId,
            createdAt: DateTime(2026, 10, 16, 11),
            orderId: 'ord-0142',
            method: PayMethod.tunai,
            amount: 31500,
            received: 50000,
            paidAt: DateTime(2026, 10, 16, 11),
          ),
        );
    await container.pump();
    final after = await reports.getReport(weekRange);
    expect(after.revenue, before.revenue);
    expect(after.cashIn, before.cashIn + 31500);
    expect(after.activeOutstanding, before.activeOutstanding - 31500);
    expect(after.newOutstanding, before.newOutstanding - 31500);
    expect(after.cashFromOrders, before.cashFromOrders + 31500);
    expect(notifications, greaterThan(0));
    sub.close();
  });

  test('all ranges calculate their own ledger without historical fallback', () async {
    final reports = container.read(reportRepositoryProvider);
    final range = ReportRange(DateTime(2025), DateTime(2026));
    expect((await reports.getReport(range)).revenue, 0);
    expect((await reports.getReport(range)).activeOutstanding, 400500);
    expect(
      (await reports.getTopServices(todayRange)).fold<int>(0, (sum, s) => sum + s.revenue),
      177000,
    );
  });
}
