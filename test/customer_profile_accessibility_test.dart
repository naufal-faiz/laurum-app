import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/customer.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_profile_section.dart';

void main() {
  testWidgets('long customer text, large balances and actual2x text retain every action', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final customer = Customer(
      id: 'responsive',
      ownerId: 'owner',
      createdAt: DateTime(2026),
      name: 'Nama Pelanggan Sangat Panjang Dengan Beberapa Kata',
      phone: '081234567890',
      address: 'Alamat pelanggan sangat panjang sampai beberapa baris',
      notes: 'Catatan pelanggan tetap tampil lengkap saat ukuran font diperbesar',
    );
    var contacts = 0, edits = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: CustomerProfileSection(
                summary: CustomerDirectoryRow(customer, 99999, 999999999, 999999999, 999999999, 0),
                onWhatsApp: () => contacts++,
                onEdit: () => edits++,
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final avatarText = find.text('NK');
    expect(tester.renderObject<RenderParagraph>(avatarText).didExceedMaxLines, isFalse);
    await tester.ensureVisible(find.text('Buka WhatsApp'));
    await tester.tap(find.text('Buka WhatsApp'));
    await tester.ensureVisible(find.text('Edit profil'));
    await tester.tap(find.text('Edit profil'));
    expect(contacts, 1);
    expect(edits, 1);
    await tester.scrollUntilVisible(find.text('Saldo tabungan laundry'), 300);
    expect(find.text(customer.notes), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
