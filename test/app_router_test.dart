import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/shell/pages/placeholder_routes.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('all PRD routes resolve, static paths win and five branches navigate', (
    tester,
  ) async {
    final host = await pumpAntrean(tester);
    for (final entry in placeholderRoutes.entries) {
      final path = entry.key.replaceAll(':id', 'test-id');
      host.router.go(path);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsWidgets, reason: path);
      expect(find.text('Halaman tidak ditemukan'), findsNothing, reason: path);
    }
    for (final path in tabRoutes.keys) {
      host.router.go(path);
      await tester.pumpAndSettle();
      expect(
        tester.widget<BottomNavBar>(find.byType(BottomNavBar)).activeIndex,
        tabRoutes.keys.toList().indexOf(path),
      );
    }
    host.router.go('/tidak-ada');
    await tester.pumpAndSettle();
    expect(find.text('Halaman tidak ditemukan'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('transaction routes replace placeholders and hide bottom nav', (tester) async {
    final host = await pumpAntrean(tester);
    host.router.go('/transaksi/baru');
    await tester.pumpAndSettle();
    expect(find.text('Buat transaksi'), findsWidgets);
    expect(find.byType(BottomNavBar), findsNothing);
    host.router.go('/transaksi/baru/layanan');
    await tester.pumpAndSettle();
    expect(find.text('Pilih layanan'), findsWidgets);
    expect(find.byType(BottomNavBar), findsNothing);
    host.router.go('/transaksi/baru/bayar');
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran'), findsWidgets);
    host.router.go('/lainnya/printer');
    await tester.pumpAndSettle();
    expect(find.text('Printer dan struk'), findsWidgets);
    expect(find.byType(BottomNavBar), findsNothing);
  });
}
