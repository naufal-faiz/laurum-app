import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/organisms/service_row.dart';

import '../widgetbook/organisms/service_row_use_case.dart';
import 'molecule_gallery.dart';

void main() {
  testWidgets('ServiceRow inactive catalog item can be enabled and edited', (tester) async {
    final service = serviceFixtures.last;
    var edited = 0;
    bool? active;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ServiceRow(
            name: service.name,
            kind: service.kind,
            price: service.price,
            durationDays: service.durationDays,
            isActive: service.isActive,
            onTap: () => edited++,
            onActiveChanged: (v) => active = v,
          ),
        ),
      ),
    );
    expect(find.text('Nonaktif'), findsOneWidget);
    expect(find.text('Rp35.000 / pcs'), findsOneWidget);
    await tester.tap(find.byType(AppSwitch));
    expect(active, true);
    expect(edited, 0);
    await tester.tap(find.text(service.name));
    expect(edited, 1);
  });
  registerMoleculeGolden('service_row', serviceRowUseCase.builder);
}
