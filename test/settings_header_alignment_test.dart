import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/shared/widgets/organisms/app_page_header.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [390, 320]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('three page headers share alignment at $width/$scale', (tester) async {
        tester.view.physicalSize = Size(width.toDouble(), 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        double? brandY, titleY, detailY;
        for (final (route, title) in [
          ('/antrean', 'Antrean'),
          ('/pelanggan', 'Pelanggan'),
          ('/lainnya', 'Lainnya'),
        ]) {
          await pumpAntrean(tester, location: route, textScale: scale);
          final header = find.byType(AppPageHeader);
          final data = tester.widget<AppPageHeader>(header);
          expect(data.title, title);
          final brand = tester
              .getTopLeft(find.descendant(of: header, matching: find.text('LAURUM')))
              .dy;
          final heading = tester
              .getTopLeft(find.descendant(of: header, matching: find.text(title)))
              .dy;
          final detail = tester
              .getTopLeft(find.descendant(of: header, matching: find.text(data.subtitle)))
              .dy;
          brandY ??= brand;
          titleY ??= heading;
          detailY ??= detail;
          expect(brand, brandY);
          expect(heading, titleY);
          expect(detail, detailY);
          expect(tester.takeException(), isNull);
        }
      });
    }
  }
  testWidgets('Pelanggan has no avatar and account remains accessible from Lainnya', (
    tester,
  ) async {
    await pumpAntrean(tester, location: '/pelanggan', textScale: 2);
    expect(find.byType(AppPageHeader), findsOneWidget);
    expect(find.text('48 pelanggan'), findsOneWidget);
    expect(tester.widget<AppPageHeader>(find.byType(AppPageHeader)).action, isNull);
    expect(find.byTooltip('Usaha dan akun'), findsNothing);
    await tester.tap(
      find.descendant(of: find.byType(BottomNavBar), matching: find.text('Lainnya')),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<AppPageHeader>(find.byType(AppPageHeader)).title, 'Lainnya');
    expect(find.byTooltip('Usaha dan akun'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
