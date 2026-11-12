import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/icons/app_svgs.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/reports/pages/report_page.dart';
import 'package:laurum/features/settings/pages/settings_page.dart';
import 'package:laurum/features/settings/widgets/settings_header_section.dart';
import 'package:laurum/shared/widgets/atoms/app_avatar.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('Lainnya keeps account action and uses business initials, WhatsApp and padding', (
    tester,
  ) async {
    await pumpAntrean(tester, location: '/lainnya');
    final header = find.byType(SettingsHeaderSection);
    final avatar = find.descendant(of: header, matching: find.byType(AppAvatar));
    expect(tester.widget<AppAvatar>(avatar).initials, 'BL');
    await tester.tap(avatar);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    final ai = find.widgetWithText(MenuRow, 'Otomatisasi AI');
    final svg = find.descendant(of: ai, matching: find.byType(AppSvg));
    expect(tester.widget<AppSvg>(svg).assetName, AppSvgs.whatsapp);
    final glyph = tester.widget<AppIcon>(
      find.descendant(of: ai, matching: find.byType(AppIcon)).first,
    );
    expect(glyph.boxColor, AppColors.successTint);
    final box = tester.widget<Container>(
      find.descendant(of: ai, matching: find.byType(Container)).first,
    );
    final decoration = box.decoration! as BoxDecoration;
    expect((decoration.border! as Border).top.color, AppColors.successTint);
    final cards = tester.widgetList<AppCard>(
      find.descendant(of: find.byType(SettingsPage), matching: find.byType(AppCard)),
    );
    expect(cards, hasLength(3));
    for (final card in cards) {
      expect(card.padding, const EdgeInsets.all(2));
    }
  });
  for (final origin in ['/lainnya', '/beranda']) {
    testWidgets('report back restores $origin', (tester) async {
      final host = await pumpAntrean(tester, location: origin);
      final pushed = host.router.push<void>('/laporan');
      await tester.pumpAndSettle();
      expect(find.byType(ReportPage), findsOneWidget);
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();
      await pushed;
      expect(find.byType(ReportPage), findsNothing);
      expect(host.router.routeInformationProvider.value.uri.path, origin);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('report back from direct link falls back to Lainnya', (tester) async {
    final host = await pumpAntrean(tester, location: '/laporan');
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    expect(host.router.routeInformationProvider.value.uri.path, '/lainnya');
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
