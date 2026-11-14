import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/services/state/service_edit_controller.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

import 'service_create_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  for (final width in [280.0, 320.0, 390.0, 600.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'create service width$width actual font$scale keeps draft, fields and all actions',
        (tester) async {
          final scope = await pumpServiceCreateUnscaled(tester, width: width, scale: scale);
          final profile = await scope.read(businessProfileProvider.future);
          expect(find.text('Layanan baru · ${profile.name}'), findsOneWidget);
          expect(tester.takeException(), isNull);
          if ((width == 390 && scale == 1) || (width == 320 && scale == 2)) {
            await expectLater(
              find.byKey(const ValueKey('service-create-golden')),
              matchesGoldenFile('goldens/service_create_${scale.toInt()}x.png'),
            );
          }
          final name = find.byType(AppTextField).first;
          final price = find.byType(AppTextField).at(1);
          await tester.ensureVisible(name);
          await tester.enterText(
            find.descendant(of: name, matching: find.byType(TextField)),
            'Karpet',
          );
          await tester.ensureVisible(price);
          await tester.enterText(
            find.descendant(of: price, matching: find.byType(TextField)),
            '07500',
          );
          await tester.pumpAndSettle();
          final type = find.widgetWithText(SelectionTile, 'Satuan');
          await tester.ensureVisible(type);
          await tester.tap(type);
          await tester.pumpAndSettle();
          final duration = find.widgetWithText(AppChip, '5 hari');
          await tester.ensureVisible(duration);
          await tester.tap(duration);
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byType(AppSwitch));
          await tester.tap(find.byType(AppSwitch));
          await tester.pumpAndSettle();
          final draft = scope.read(serviceEditProvider('')).value!;
          expect(draft.name, 'Karpet');
          expect(draft.price, 7500);
          expect(draft.kind, ServiceKind.satuan);
          expect(draft.durationDays, 5);
          expect(draft.isActive, isFalse);
          expect(find.text('Rp7.500/pcs'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
