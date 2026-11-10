import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/features/beranda/widgets/beranda_header_section.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/features/orders/state/antrean_search.dart';
import 'package:laurum/features/orders/widgets/antrean_header_section.dart';
import 'package:laurum/shared/widgets/atoms/app_search_field.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/organisms/proposal_card.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('two recommendation previews keep every proposal in see-all', (tester) async {
    final host = await pumpAntrean(tester);
    expect(find.byType(ProposalCard), findsNWidgets(2));
    await tester.tap(find.text('Lihat semua (3)'));
    await tester.pumpAndSettle();
    expect(host.container.read(antreanFilterProvider), 4);
    expect(find.byType(ProposalCard), findsNWidgets(3));
    expect(find.text('Agus Pratama'), findsOneWidget);
  });
  for (final scale in [1.0, 2.0]) {
    testWidgets('LAURUM aligns with Beranda at scale $scale', (tester) async {
      final host = await pumpAntrean(tester, location: '/beranda', textScale: scale);
      final homeBrand = find.descendant(
        of: find.byType(BerandaHeaderSection),
        matching: find.text('LAURUM'),
      );
      final y = tester.getTopLeft(homeBrand).dy;
      host.router.go('/antrean');
      await tester.pumpAndSettle();
      final queueBrand = find.descendant(
        of: find.byType(AntreanHeaderSection),
        matching: find.text('LAURUM'),
      );
      expect(tester.getTopLeft(queueBrand).dy, closeTo(y, .1));
      expect(find.byTooltip('Usaha dan akun'), findsNothing);
      expect(tester.takeException(), isNull);
    });
    testWidgets('Antrean search at 320dp, scale $scale and keyboard 300dp', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final host = await pumpAntrean(tester, textScale: scale);
      await tester.tap(find.byTooltip('Cari antrean'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      final input = find.descendant(
        of: find.byType(AppSearchField),
        matching: find.byType(TextField),
      );
      expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
      expect(tester.getRect(input).bottom, lessThanOrEqualTo(544));
      expect(tester.getRect(find.byTooltip('Tutup pencarian')).bottom, lessThanOrEqualTo(544));
      await tester.enterText(input, 'A-0142');
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('ord-0142')), findsOneWidget);
      expect(find.byKey(const ValueKey('ord-0141')), findsNothing);
      await tester.enterText(input, 'tidak-ada-hasil-xyz');
      await tester.pumpAndSettle();
      expect(find.text('Tidak ada hasil pencarian'), findsOneWidget);
      await tester.tap(find.byTooltip('Hapus pencarian'));
      await tester.pumpAndSettle();
      expect(host.container.read(antreanSearchProvider).query, '');
      await tester.tap(find.byTooltip('Tutup pencarian'));
      tester.view.resetViewInsets();
      await tester.pumpAndSettle();
      expect(find.byType(AppSearchField), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('rapid tab switches preserve filter and scroll position', (tester) async {
    final host = await pumpAntrean(tester);
    await tester.tap(find.byTooltip('Filter status'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Proses 5'));
    await tester.pumpAndSettle();
    final scrollable = find
        .descendant(of: find.byType(ListView).first, matching: find.byType(Scrollable))
        .first;
    final position = tester.state<ScrollableState>(scrollable).position;
    await tester.drag(find.byType(ListView).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    final offset = position.pixels;
    final nav = find.byType(BottomNavBar);
    await tester.tap(find.descendant(of: nav, matching: find.text('Beranda')));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.tap(find.descendant(of: nav, matching: find.text('Antrean')));
    await tester.pumpAndSettle();
    expect(host.container.read(antreanFilterProvider), 2);
    expect(tester.state<ScrollableState>(scrollable).position, same(position));
    expect(position.pixels, offset);
    expect(tester.takeException(), isNull);
  });
}
