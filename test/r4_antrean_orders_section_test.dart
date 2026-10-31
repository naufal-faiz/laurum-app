import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/widgets/antrean_orders_section.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('AntreanOrdersSection delegates open/advance and respects mode/pending', (
    tester,
  ) async {
    final scope = ProviderContainer(overrides: dummyRepositoryOverrides);
    addTearDown(scope.dispose);
    final data = await scope.read(antreanDataProvider.future);
    final order = data.orders.singleWhere((o) => o.id == 'ord-0142');
    for (final enabled in [true, false]) {
      for (final busy in [true, false]) {
        var opens = 0, advances = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: SingleChildScrollView(
                child: AntreanOrdersSection(
                  data: data,
                  orders: [order],
                  pending: busy ? {order.id} : {},
                  useOrderStatus: enabled,
                  onOpen: (value) {
                    expect(value.id, order.id);
                    opens++;
                  },
                  onAdvance: (value) {
                    expect(value.id, order.id);
                    advances++;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('A-0142'));
        expect(opens, 1);
        if (enabled) {
          final button = tester.widget<AppButton>(find.byType(AppButton));
          expect(button.onPressed == null, busy);
          if (!busy) await tester.tap(find.text('Tandai siap'));
        } else {
          expect(find.byType(AppButton), findsNothing);
        }
        expect(advances, enabled && !busy ? 1 : 0);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
