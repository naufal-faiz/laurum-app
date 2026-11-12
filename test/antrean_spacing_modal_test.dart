import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/orders/pages/antrean_filter_sheet.dart';
import 'package:laurum/features/orders/state/antrean_controller.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('summary sits near title and section titles use primary', (tester) async {
    await pumpAntrean(tester);
    final title = find.text('Antrean').first;
    final summary = find.textContaining(RegExp(r'^12 order aktif\b'));
    expect(tester.getTopLeft(summary).dy - tester.getBottomLeft(title).dy, inInclusiveRange(0, 12));
    for (final label in ['Rekomendasi AI', 'Antrean berjalan']) {
      await tester.scrollUntilVisible(
        find.text(label),
        200,
        scrollable: find
            .descendant(of: find.byType(ListView).first, matching: find.byType(Scrollable))
            .first,
      );
      expect(tester.widget<AppText>(find.widgetWithText(AppText, label)).color, AppColors.primary);
    }
  });
  testWidgets('filter modal covers navigation and last option remains tappable', (tester) async {
    final host = await pumpAntrean(tester);
    await tester.tap(find.byTooltip('Filter status'));
    await tester.pumpAndSettle();
    final sheet = find.byType(AntreanFilterSheet);
    final context = tester.element(sheet);
    expect(ModalRoute.of(context)!.navigator, Navigator.of(context, rootNavigator: true));
    final review = find.descendant(of: sheet, matching: find.text('Perlu dicek 3'));
    expect(review.hitTestable(), findsOneWidget);
    await tester.tap(review);
    await tester.pumpAndSettle();
    expect(host.container.read(antreanFilterProvider), 4);
    expect(find.byType(AntreanFilterSheet), findsNothing);
    expect(tester.widget<BottomNavBar>(find.byType(BottomNavBar)).activeIndex, 1);
    expect(tester.takeException(), isNull);
  });
}
