import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

import '../widgetbook/templates/root_scaffold_use_case.dart';
import 'template_gallery.dart';

void main() {
  testWidgets('RootScaffold composes app bar, nav, and optional FAB', (tester) async {
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
          fabLabel: 'Transaksi baru',
          onFab: () => fabTaps++,
          onTabSelected: (index) => selectedTab = index,
          body: const AppText('Isi layar'),
        ),
      ),
    );
    expect(find.text('Antrean'), findsWidgets);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Isi layar'), findsOneWidget);
    await tester.tap(find.text('Laporan'));
    expect(selectedTab, 3);
    await tester.tap(find.text('Transaksi baru'));
    expect(fabTaps, 1);
  });
  registerTemplateGallery('root_scaffold', rootScaffoldUseCases.first.builder);
}
