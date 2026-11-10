import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

import '../widgetbook/templates/root_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('RootScaffold composes four tabs and create action without FAB', (tester) async {
    int? selectedTab;
    var fabTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RootScaffold(
          title: 'Antrean',
          accountLabel: 'Akun',
          activeIndex: 0,
          syncState: SyncState.offline,
          onCreate: () => fabTaps++,
          onTabSelected: (index) => selectedTab = index,
          body: const AppText('Isi layar'),
        ),
      ),
    );
    expect(find.text('Antrean'), findsWidgets);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Isi layar'), findsOneWidget);
    await tester.tap(find.text('Pelanggan'));
    expect(selectedTab, 2);
    expect(find.byType(FloatingActionButton), findsNothing);
    await tester.tap(find.text('Transaksi'));
    expect(fabTaps, 1);
  });
  testWidgets('showAppBar false hides the account bar but keeps the nav', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const RootScaffold(
          title: 'Beranda',
          accountLabel: 'Akun',
          activeIndex: 0,
          showAppBar: false,
          body: AppText('Isi beranda'),
        ),
      ),
    );
    expect(find.text('Isi beranda'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(BottomNavBar), matching: find.text('Beranda')),
      findsOneWidget,
    );
    expect(find.byTooltip('Akun'), findsNothing);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).appBar, isNull);
  });
  registerTemplateGallery('root_scaffold', rootScaffoldUseCases.first.builder);

  testWidgets('brand header replaces the account bar without a blank toolbar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const RootScaffold(
          title: 'Beranda',
          accountLabel: 'Akun',
          activeIndex: 0,
          showAppBar: false,
          header: AppText('Merek'),
          body: AppText('Konten'),
        ),
      ),
    );
    expect(find.byTooltip('Akun'), findsNothing);
    final header = tester.getRect(find.text('Merek'));
    final content = tester.getRect(find.text('Konten'));
    expect(content.top, header.bottom);
  });
}
