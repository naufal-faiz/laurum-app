import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/features/customers/data/contact_fixtures.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));

  testWidgets('fixture contacts are already registered and skipped', (tester) async {
    await pumpAntrean(tester, location: '/pelanggan/impor');
    expect(
      find.text('4 nomor sudah terdaftar di sistem dan akan otomatis dilewati'),
      findsOneWidget,
    );
    expect(find.text('0 kontak baru dipilih (4 dilewati)'), findsOneWidget);
    expect(find.text('Pilih semua (0 kontak)'), findsOneWidget);
    expect(find.text('Simpan 0 pelanggan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'agus');
    await tester.pumpAndSettle();
    expect(find.text('Agus Pratama'), findsOneWidget);
    expect(find.text('Siti Rohmah'), findsNothing);
  });

  testWidgets('new contact can be selected and saved into the directory', (tester) async {
    final container = ProviderContainer(
      overrides: dummyOverrides(
        contactSource: FakeContactSource(
          contacts: [
            ...contactFixtures,
            const ContactItem(name: 'Zulaikha Baru', phone: '0812-3333-4444'),
          ],
        ),
      ),
    );
    await pumpAntrean(tester, location: '/pelanggan', container: container);
    await tester.tap(find.text('Impor kontak'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih semua (1 kontak)'), findsOneWidget);
    await tester.tap(find.text('Pilih semua (1 kontak)'));
    await tester.pumpAndSettle();
    expect(find.text('Simpan 1 pelanggan'), findsOneWidget);
    await tester.tap(find.text('Simpan 1 pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Semua (49)'), findsOneWidget);
  });

  testWidgets('denied permission offers system settings', (tester) async {
    final container = ProviderContainer(
      overrides: dummyOverrides(
        contactSource: FakeContactSource(permissionDenied: true),
      ),
    );
    await pumpAntrean(tester, location: '/pelanggan/impor', container: container);
    expect(find.text('Izin kontak belum diberikan'), findsOneWidget);
    expect(find.text('Izinkan akses kontak agar nomor bisa diimpor.'), findsOneWidget);
    await tester.tap(find.text('Buka pengaturan'));
    await tester.pumpAndSettle();
    final launcher = container.read(externalLauncherProvider) as FakeExternalLauncher;
    expect(launcher.launchedUrls, ['app-settings:']);
  });
}
