import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_badge.dart';
import 'package:laurum/shared/widgets/molecules/app_bar_sub.dart';
import 'package:laurum/shared/widgets/molecules/payment_badge.dart';

import 'test_fonts.dart';

void main() {
  testWidgets('detail molecules golden', (tester) async {
    await loadTestFonts();
    tester.view.physicalSize = const Size(390, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const ValueKey('detail-molecules'),
          child: Scaffold(
            body: Column(
              children: [
                AppBarSub(
                  title: 'Periksa Usulan AI',
                  subtitle: 'Dari pesan WhatsApp · 09.12 WIB',
                  backLabel: 'Kembali',
                  variant: AppBarSubVariant.detail,
                  onBack: () {},
                  trailing: const AppBadge('Perlu dicek', variant: AppBadgeVariant.diproses),
                ),
                const PaymentBadge(label: 'Lunas', status: PayStatus.lunas),
                const PaymentBadge(label: 'Sisa Rp20.000', status: PayStatus.dp),
                const PaymentBadge(label: 'COD - sisa Rp31.500', status: PayStatus.belumBayar),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('detail-molecules')),
      matchesGoldenFile('goldens/detail_molecules.png'),
    );
  });
}
