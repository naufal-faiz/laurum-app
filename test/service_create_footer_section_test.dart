import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/widgets/service_form_footer_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'service_create_test_host.dart';

void main() {
  testWidgets('footer preserves save then cancel focus despite visual order', (tester) async {
    await pumpServiceSection(
      tester,
      ServiceFormFooterSection(busy: false, onSave: () {}, onCancel: () {}),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(Focus.of(tester.element(find.text('Simpan layanan'))).hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(Focus.of(tester.element(find.text('Batal'))).hasPrimaryFocus, isTrue);
  });
  testWidgets('ServiceFormFooterSection maps actions, aligns and disables while busy', (
    tester,
  ) async {
    var saves = 0, cancels = 0;
    await pumpServiceSection(
      tester,
      ServiceFormFooterSection(busy: false, onSave: () => saves++, onCancel: () => cancels++),
    );
    final save = find.widgetWithText(AppButton, 'Simpan layanan');
    final cancel = find.widgetWithText(AppButton, 'Batal');
    expect(tester.getTopLeft(cancel).dx, lessThan(tester.getTopLeft(save).dx));
    await tester.tap(save);
    await tester.tap(cancel);
    expect(saves, 1);
    expect(cancels, 1);
    await pumpServiceSection(
      tester,
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: ServiceFormFooterSection(
          busy: true,
          onSave: () => saves++,
          onCancel: () => cancels++,
        ),
      ),
    );
    expect(tester.getTopLeft(cancel).dy, lessThan(tester.getTopLeft(save).dy));
    expect(
      tester
          .widgetList<AppButton>(find.byType(AppButton))
          .every((button) => button.onPressed == null),
      isTrue,
    );
    expect(saves, 1);
    expect(cancels, 1);
  });
}
