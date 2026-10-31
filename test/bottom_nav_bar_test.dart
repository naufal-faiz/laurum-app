import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import '../widgetbook/organisms/bottom_nav_bar_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('BottomNavBar labels, active glyph and external selection', (tester) async {
    var selected = -1;
    var creates = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(
            activeIndex: 1,
            onSelected: (i) => selected = i,
            onCreate: () => creates++,
          ),
        ),
      ),
    );
    expect(find.text('Antrean'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
    expect(
      tester.widgetList<AppIcon>(find.byType(AppIcon)).map((i) => i.icon),
      contains(AppIcons.customersActive),
    );
    await tester.tap(find.text('Transaksi'));
    expect(creates, 1);
    expect(selected, -1);
    for (final (index, label) in ['Antrean', 'Pelanggan', 'Laporan', 'Lainnya'].indexed) {
      await tester.tap(find.text(label));
      expect(selected, index);
    }
    expect(
      tester.widgetList<AppIcon>(find.byType(AppIcon)).map((i) => i.icon),
      contains(AppIcons.customersActive),
    );
  });
  registerMoleculeGolden('bottom_nav_bar', bottomNavBarUseCase.builder);
  testWidgets('create action uses material ink feedback once per tap', (tester) async {
    var creates = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          bottomNavigationBar: BottomNavBar(activeIndex: 0, onCreate: () => creates++),
        ),
      ),
    );
    final ink = find.descendant(
      of: find.byType(BottomNavBar),
      matching: find.byType(InkWell),
    );
    expect(ink, findsOneWidget);
    await tester.tap(ink);
    await tester.pump();
    expect(creates, 1);
  });
  testWidgets('320px and 2x text keep raised create action visible and accessible', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    var creates = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            bottomNavigationBar: BottomNavBar(
              activeIndex: 2,
              onCreate: () => creates++,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Transaksi baru')),
      matchesSemantics(
        label: 'Transaksi baru',
        isButton: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    final circle = tester.getRect(
      find.descendant(of: find.byType(BottomNavBar), matching: find.byType(InkWell)),
    );
    await tester.tapAt(Offset(circle.center.dx, circle.top + 4));
    expect(creates, 1);
    semantics.dispose();
  });
}
