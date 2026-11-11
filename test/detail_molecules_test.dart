import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/payment_badge.dart';
import 'package:laurum/shared/widgets/molecules/section_header.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('detail header wraps and preserves actions at 320dp/$scale', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var backs = 0, menus = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Scaffold(
              body: Column(
                children: [
                  AppBarSub(
                    title: 'Periksa Usulan AI',
                    subtitle: 'Dari pesan WhatsApp · 09.12 WIB',
                    backLabel: 'Kembali',
                    variant: AppBarSubVariant.detail,
                    onBack: () => backs++,
                    trailing: AppIconButton(
                      icon: AppIcons.more,
                      label: 'Menu',
                      onPressed: () => menus++,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('Periksa Usulan AI'), findsOneWidget);
      expect(tester.widget<Text>(find.text('Periksa Usulan AI')).overflow, isNull);
      await tester.tap(find.byTooltip('Kembali'));
      await tester.tap(find.byTooltip('Menu'));
      expect([backs, menus], [1, 1]);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('payment badges render existing labels with semantic status colors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: Column(
            children: [
              PaymentBadge(label: 'Lunas', status: PayStatus.lunas),
              PaymentBadge(label: 'Sisa Rp20.000', status: PayStatus.dp),
              PaymentBadge(label: 'COD - sisa Rp999.999.999', status: PayStatus.belumBayar),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.widget<AppText>(find.widgetWithText(AppText, 'Lunas')).color,
      AppColors.successInk,
    );
    expect(
      tester.widget<AppText>(find.widgetWithText(AppText, 'Sisa Rp20.000')).color,
      AppColors.warningInk,
    );
    expect(
      tester.widget<AppText>(find.widgetWithText(AppText, 'COD - sisa Rp999.999.999')).color,
      AppColors.errorInk,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('section trailing is informative and preserves action callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Rincian cucian',
            trailing: const AppText('2 layanan'),
            actionLabel: 'Buka',
            onAction: () => taps++,
          ),
        ),
      ),
    );
    expect(find.text('2 layanan'), findsOneWidget);
    await tester.tap(find.text('Buka'));
    expect(taps, 1);
  });
}
