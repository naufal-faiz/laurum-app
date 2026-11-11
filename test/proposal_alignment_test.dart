import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/callout_ai.dart';
import 'package:laurum/shared/widgets/molecules/notice_ai.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('proposal title tight, pending centered and accuracy justified', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpAntrean(tester, location: '/antrean/usulan/prop-002');
    final title = tester.getRect(find.text('Periksa Usulan AI'));
    final subtitle = tester.getRect(find.textContaining('Pesan WhatsApp'));
    final badge = tester.getRect(find.widgetWithText(AppBadge, 'Perlu dicek'));
    expect(subtitle.top, title.bottom);
    expect(badge.center.dy, closeTo(title.expandToInclude(subtitle).center.dy, 0.1));
    final source = find.text('Dibaca dari pesan WhatsApp');
    final accuracy = find.text('Contoh akurasi 89%');
    expect(tester.getRect(source).center.dy, closeTo(tester.getRect(accuracy).center.dy, 0.1));
    final scoreBadge = find.widgetWithText(AppBadge, 'Contoh akurasi 89%');
    final row = find.ancestor(of: scoreBadge, matching: find.byType(Row)).first;
    expect(tester.getRect(scoreBadge).right, tester.getRect(row).right);
    final privacyIcon = find.byWidgetPredicate((w) => w is AppIcon && w.icon == AppIcons.privacy);
    await tester.ensureVisible(privacyIcon);
    await tester.pumpAndSettle();
    expect(
      tester.getRect(privacyIcon).center.dy,
      closeTo(tester.getRect(find.text(NoticeAi.message)).center.dy, 0.1),
    );
    final address = tester.widget<AppTextField>(find.byType(AppTextField));
    expect((address.dense, address.selectAllOnFocus, address.maxLines), (true, true, 3));
    expect(tester.takeException(), isNull);
  });
  testWidgets('all banner variants use compact text and centered icon', (tester) async {
    for (final variant in BannerMessageVariant.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SizedBox(
              width: 240,
              child: BannerMessage(
                message: 'Informasi yang cukup panjang untuk membungkus beberapa baris.',
                variant: variant,
              ),
            ),
          ),
        ),
      );
      final text = find.byType(AppText);
      expect(tester.widget<AppText>(text).variant, AppTextVariant.caption);
      expect(
        tester.getRect(find.byType(AppIcon)).center.dy,
        closeTo(tester.getRect(text).center.dy, 0.1),
      );
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('compact uncertainty uses badge and centers icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SizedBox(
            width: 240,
            child: CalloutAi(
              message: 'AI kurang yakin dengan nomor rumah/patokan detail.',
              compact: true,
            ),
          ),
        ),
      ),
    );
    expect(find.widgetWithText(AppBadge, 'Periksa bagian ini'), findsOneWidget);
    expect(tester.widget<AppIcon>(find.byType(AppIcon)).icon, AppIcons.location);
    final block = find.ancestor(of: find.byType(AppBadge), matching: find.byType(Column)).first;
    expect(
      tester.getRect(find.byType(AppIcon)).center.dy,
      closeTo(tester.getRect(block).center.dy, 0.1),
    );
    expect(
      tester
          .widget<AppText>(
            find.widgetWithText(AppText, 'AI kurang yakin dengan nomor rumah/patokan detail.'),
          )
          .variant,
      AppTextVariant.caption,
    );
  });
}
