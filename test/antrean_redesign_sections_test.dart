import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/widgets/antrean_header_section.dart';
import 'package:laurum/features/orders/widgets/antrean_proposals_section.dart';
import 'package:laurum/features/orders/widgets/antrean_toolbar_section.dart';
import 'package:laurum/main_dummy.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('AntreanToolbarSection delegates review and filter controls', (tester) async {
    int? selected;
    var filters = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AntreanToolbarSection(
            labels: const ['Semua 12', 'Perlu dicek 3'],
            selectedIndex: 0,
            onSelected: (value) => selected = value,
            onFilter: () => filters++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Perlu dicek 3'));
    await tester.tap(find.byTooltip('Filter status'));
    expect(selected, 1);
    expect(filters, 1);
  });
  testWidgets('AntreanHeaderSection shows brand and delegates search', (tester) async {
    var searches = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AntreanHeaderSection(searchOpen: false, onSearch: () => searches++),
        ),
      ),
    );
    expect(find.text('LAURUM'), findsOneWidget);
    expect(find.text('Antrean'), findsOneWidget);
    await tester.tap(find.byTooltip('Cari antrean'));
    expect(searches, 1);
  });
  testWidgets('shared Antrean header keeps counts and synchronization', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AntreanHeaderSection(
            searchOpen: false,
            onSearch: () {},
            total: 12,
            reviewCount: 3,
          ),
        ),
      ),
    );
    expect(find.text('12 order aktif · 3 perlu dicek'), findsOneWidget);
    expect(find.text('Tersimpan'), findsOneWidget);
    expect(find.byTooltip('Usaha dan akun'), findsNothing);
  });
  testWidgets('AntreanProposalsSection keeps full text, pending and callbacks', (tester) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final data = await scope.read(antreanDataProvider.future);
    var sees = 0, opens = 0, rejects = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AntreanProposalsSection(
              data: data,
              proposals: data.proposals.take(1).toList(),
              pending: const {},
              onSeeAll: () => sees++,
              onOpen: (_) => opens++,
              onReject: (_) => rejects++,
            ),
          ),
        ),
      ),
    );
    expect(find.text(data.proposals.first.sourceText), findsOneWidget);
    await tester.tap(find.text('Lihat semua (3)'));
    await tester.tap(find.text('Periksa'));
    await tester.tap(find.text('Tolak'));
    expect([sees, opens, rejects], [1, 1, 1]);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AntreanProposalsSection(
            data: data,
            proposals: data.proposals.take(1).toList(),
            pending: {data.proposals.first.id},
            onSeeAll: () {},
            onOpen: (_) {},
            onReject: (_) => rejects++,
          ),
        ),
      ),
    );
    expect(tester.widget<TextButton>(find.widgetWithText(TextButton, 'Tolak')).onPressed, isNull);
  });
}
