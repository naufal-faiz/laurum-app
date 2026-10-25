import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('service directory lists six services and toggles cashier catalog', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/layanan');
    expect(find.text('Total 6 layanan (5 aktif)'), findsOneWidget);
    expect(find.text('Cuci kering lipat'), findsOneWidget);
    expect(find.text('Bed cover'), findsOneWidget);

    await tester.dragUntilVisible(
      find.text('Jas & gaun'),
      find.byType(ListView),
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nonaktif'), findsOneWidget);
    expect(find.text('4 hari'), findsOneWidget);
    await tester.ensureVisible(find.byType(AppSwitch).last);
    await tester.tap(find.byType(AppSwitch).last);
    await tester.pumpAndSettle();
    expect(find.text('Total 6 layanan (6 aktif)'), findsOneWidget);

    host.router.go('/transaksi/baru/layanan');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'jas');
    await tester.pumpAndSettle();
    expect(find.text('Jas & gaun'), findsOneWidget);
  });

  testWidgets('add service validates, saves, and appears in picker', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/layanan');
    await tester.tap(find.text('Tambah layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah layanan'), findsOneWidget);

    await tester.tap(find.text('Simpan layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama layanan wajib diisi.'), findsOneWidget);
    expect(find.text('Harga harus lebih dari Rp0.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Karpet');
    await tester.enterText(find.byType(TextField).at(1), '30000');
    await tester.tap(find.text('Satuan (per pcs)'));
    await tester.pumpAndSettle();
    expect(find.text('Harga (per pcs)'), findsOneWidget);
    await tester.tap(find.text('5 hari'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan layanan'));
    await tester.pumpAndSettle();

    expect(find.text('Total 7 layanan (6 aktif)'), findsOneWidget);
    final services = await host.container
        .read(serviceRepositoryProvider)
        .getServices(includeInactive: true);
    final added = services.where((s) => s.name == 'Karpet').single;
    expect(added.price, 30000);
    expect(added.durationDays, 5);
    expect(added.isActive, isTrue);

    host.router.go('/transaksi/baru/layanan');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'karpet');
    await tester.pumpAndSettle();
    expect(find.text('Karpet'), findsOneWidget);
    expect(find.textContaining('Rp30.000/pcs'), findsOneWidget);
  });

  testWidgets('edit service shows price note and persists changes', (tester) async {
    final host = await pumpAntrean(tester, location: '/lainnya/layanan');
    await tester.ensureVisible(find.text('Cuci setrika'));
    await tester.tap(find.text('Cuci setrika'));
    await tester.pumpAndSettle();

    expect(find.text('Edit layanan'), findsOneWidget);
    expect(
      find.text('Perubahan harga tidak memengaruhi nota yang sudah tercetak.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField).at(1), '9500');
    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();

    final service = await host.container.read(serviceRepositoryProvider).getServiceById('srv-003');
    expect(service!.price, 9500);
    await tester.ensureVisible(find.text('Rp9.500 / kg'));
    expect(find.text('Rp9.500 / kg'), findsOneWidget);
  });

  testWidgets('service screens fit 320 px with 2x text', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/lainnya/layanan', textScale: 2);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Tambah layanan'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah layanan'), findsOneWidget);
    expect(find.text('Simpan layanan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
