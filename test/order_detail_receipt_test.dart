import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/orders/widgets/order_detail_footer_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

import 'antrean_test_host.dart';
import 'r4_completion_test_host.dart';
import 'r9_checkout_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final target in ['tracking', 'trackingLarge', 'cod', 'final']) {
    testWidgets('Detail $target opens receipt before any printer call', (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final printer = CompletionPrinter();
      final tracking = target.startsWith('tracking');
      final scope = await completionScope(printer, tracking: tracking);
      printer.disconnect();
      final repo = scope.read(orderRepositoryProvider);
      final id = target == 'cod'
          ? (await r9Checkout(scope)).order.id
          : target == 'final'
          ? (await repo.getOrders(status: OrderStatus.selesai)).first.id
          : 'ord-0142';
      final before = (await repo.getOrderById(id))!;
      await pumpAntrean(
        tester,
        container: scope,
        location: '/order/$id',
        textScale: target == 'trackingLarge' ? 2 : 1,
      );
      if (tracking) {
        final print = tester.getRect(find.widgetWithText(AppButton, 'Cetak struk'));
        final ready = tester.getRect(find.widgetWithText(AppButton, 'Tandai siap'));
        expect(print.size, ready.size);
        expect(print.top, ready.top);
        final labels = find.descendant(
          of: find.byType(OrderDetailFooterSection),
          matching: find.byType(AppText),
        );
        expect(
          tester
              .widgetList<AppText>(labels)
              .every((text) => text.variant == AppTextVariant.bodyStrong),
          isTrue,
        );
        await expectLater(
          find.byKey(const ValueKey('antrean-golden')),
          matchesGoldenFile(
            'goldens/order_detail_actions_${target == 'trackingLarge' ? 2 : 1}x.png',
          ),
        );
      }
      await tester.tap(find.text('Cetak struk'));
      await tester.pumpAndSettle();
      expect(find.text('Nota tersimpan'), findsOneWidget);
      expect(find.text('Printer belum terhubung'), findsOneWidget);
      expect(printer.calls, 0);
      expect((await repo.getOrderById(id))!.status, before.status);
      await tester.ensureVisible(find.byTooltip('Cetak struk'));
      await tester.tap(find.byTooltip('Cetak struk'));
      await tester.pumpAndSettle();
      expect(printer.calls, 1);
      expect(find.textContaining('Struk gagal dicetak'), findsOneWidget);
      await tester.ensureVisible(find.text('Pengaturan printer'));
      await tester.tap(find.text('Pengaturan printer'));
      await tester.pumpAndSettle();
      expect(find.text('Printer dan struk'), findsOneWidget);
      expect((await repo.getOrderById(id))!.status, before.status);
      expect(tester.takeException(), isNull);
    });
  }
}
