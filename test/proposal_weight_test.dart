import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/id_generator_provider.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/main_dummy.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';

import 'antrean_test_host.dart';
import 'fake_id_generator.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('berat opsional terisi saat menyetujui usulan kiloan', (tester) async {
    final host = await pumpAntrean(
      tester,
      location: '/antrean/usulan/prop-002',
      container: ProviderContainer(
        overrides: [
          ...dummyRepositoryOverrides,
          idGeneratorProvider.overrideWithValue(
            FakeIdGenerator(derivedValues: {'prop-002/order': 'ord-ai-prop-002'}),
          ),
        ],
      ),
    );
    await tester.ensureVisible(find.text('Isi berat'));
    await tester.tap(find.text('Isi berat'));
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == 'Berat'),
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);
    await tester.enterText(field, '4,5');
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller!.text, '4,5');
    await tester.tap(find.widgetWithText(AppButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('4,5 kg'), findsOneWidget);
    expect(find.text('Rp40.500'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, 'Setujui jadi order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Setujui jadi order').last);
    await tester.pumpAndSettle();
    final order = (await host.container
        .read(orderRepositoryProvider)
        .getOrderById('ord-ai-prop-002'))!;
    expect(order.subtotal, 40500);
    expect(order.total, 40500);
    expect(order.note, isNot(contains('Berat belum diisi')));
  });
}
