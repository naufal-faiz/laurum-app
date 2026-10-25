import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('business info saves profile, app bar and receipt follow', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/info-usaha');
    expect(find.text('Info usaha'), findsOneWidget);
    expect(find.text('Berkah Laundry'), findsOneWidget);
    expect(find.text('Jl. Melati No. 4, Sukajadi, Bandung'), findsOneWidget);
    expect(find.text('0812-3456-7890'), findsOneWidget);
    expect(find.text('Terima kasih atas kepercayaan Anda'), findsOneWidget);
    expect(find.text('Nomor telepon ditampilkan di struk.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Laundry Bersih');
    await tester.enterText(find.byType(TextField).at(2), '0812-1111-2222');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Info usaha disimpan.'), findsOneWidget);

    final profile = await host.container.read(businessRepositoryProvider).getProfile();
    expect(profile.name, 'Laundry Bersih');
    expect(profile.phone, '0812-1111-2222');

    host.router.go('/lainnya');
    await tester.pumpAndSettle();
    expect(find.text('Laundry Bersih'), findsOneWidget);

    final order = await host.container.read(orderRepositoryProvider).getOrderByOrderNo('A-0141');
    host.router.go('/transaksi/nota/${order!.id}');
    await tester.pumpAndSettle();
    expect(find.text('Nota tersimpan'), findsOneWidget);
    expect(find.textContaining('LAUNDRY BERSIH'), findsWidgets);
  });

  testWidgets('business name is required', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/info-usaha');
    await tester.enterText(find.byType(TextField).first, ' ');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama usaha wajib diisi.'), findsOneWidget);
    final profile = await host.container.read(businessRepositoryProvider).getProfile();
    expect(profile.name, 'Berkah Laundry');
  });
}
