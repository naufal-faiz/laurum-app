import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/widgets/transaction_item_section.dart';
import 'package:laurum/features/transactions/widgets/transaction_services_section.dart';
import 'package:laurum/features/transactions/widgets/transaction_summary_section.dart';

import 'test_fonts.dart';

void main() {
  final line = DraftLine(serviceFixtures.first, 1000);
  testWidgets('item at 320dp 2x keeps edit and trash separate', (tester) async {
    await loadTestFonts();
    tester.view.physicalSize = const Size(320, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var edits = 0, removes = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: TransactionItemSection(
              line: line,
              onEdit: () => edits++,
              onRemove: () => removes++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.textContaining('Ubah'));
    expect((edits, removes), (1, 0));
    await tester.tap(find.byTooltip('Hapus ${line.service.name}'));
    expect((edits, removes), (1, 1));
    expect(find.text(Formatters.rupiah(line.total)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final empty in [false, true]) {
    testWidgets('services empty=$empty delegates add/edit/remove', (tester) async {
      var adds = 0;
      var edit = '', remove = '';
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TransactionServicesSection(
                lines: empty ? [] : [line],
                onAdd: () => adds++,
                onEdit: (id) => edit = id,
                onRemove: (id) => remove = id,
              ),
            ),
          ),
        ),
      );
      if (empty) {
        expect(find.text('Belum ada layanan'), findsOneWidget);
        await tester.tapAt(tester.getTopLeft(find.text('Belum ada layanan')) - const Offset(30, 0));
      } else {
        await tester.tap(find.textContaining('Ubah'));
        await tester.tap(find.byTooltip('Hapus ${line.service.name}'));
        expect((edit, remove), (line.service.id, line.service.id));
        await tester.tap(find.text('Tambah layanan lain'));
      }
      expect(adds, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('summary shows prices and delegates discount', (tester) async {
    var edits = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: TransactionSummarySection(
            subtotal: line.total,
            discount: 0,
            total: line.total,
            onDiscount: () => edits++,
          ),
        ),
      ),
    );
    expect(find.text('Ringkasan'), findsOneWidget);
    expect(find.text(Formatters.rupiah(line.total)), findsNWidgets(2));
    await tester.tap(find.text('Atur diskon'));
    expect(edits, 1);
  });
}
