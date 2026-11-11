import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

import 'r9_section_host.dart';

void main() {
  testWidgets('selection tile delegates whole-row taps and exposes selected state', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      var taps = 0;
      await pumpR9Section(
        tester,
        SelectionTile(
          label: 'Tunai',
          subtitle: 'Uang diterima langsung',
          icon: AppIcons.wallet,
          selected: true,
          onPressed: () => taps++,
        ),
      );
      expect(
        tester.getSemantics(find.byType(TextButton)),
        matchesSemantics(
          label: 'Tunai\nUang diterima langsung',
          isButton: true,
          isSelected: true,
          isEnabled: true,
          hasEnabledState: true,
          hasSelectedState: true,
          isFocusable: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      await tester.tapAt(
        tester.getRect(find.byType(SelectionTile)).centerLeft + const Offset(4, 0),
      );
      expect(taps, 1);
    } finally {
      semantics.dispose();
    }
  });
  testWidgets('selection tile golden includes selected, idle and wrapped labels', (tester) async {
    tester.view.physicalSize = const Size(320, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpR9Section(
      tester,
      Column(
        children: [
          SelectionTile(
            label: 'Tunai',
            subtitle: 'Uang diterima langsung',
            icon: AppIcons.wallet,
            selected: true,
            onPressed: () {},
          ),
          SelectionTile(
            label: 'Transfer',
            icon: AppIcons.reports,
            selected: false,
            onPressed: () {},
          ),
          SelectionTile(label: 'Bayar nanti (COD)', selected: false, onPressed: () {}),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/selection_tile.png'));
  });
}
