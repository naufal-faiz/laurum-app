import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_preview_section.dart';
import 'package:laurum/features/services/widgets/service_type_section.dart';
import 'package:laurum/shared/widgets/molecules/selection_tile.dart';

import 'service_create_test_host.dart';

void main() {
  testWidgets('ServicePreviewSection reflects current draft and empty fallback', (tester) async {
    await pumpServiceSection(
      tester,
      const ServicePreviewSection(
        state: ServiceEditState(
          name: 'Karpet',
          kind: ServiceKind.satuan,
          priceText: '30000',
          durationDays: 5,
        ),
      ),
    );
    expect(find.text('Karpet'), findsOneWidget);
    expect(find.text('Rp30.000/pcs'), findsOneWidget);
    expect(find.text('5 hari'), findsOneWidget);
    await pumpServiceSection(tester, const ServicePreviewSection(state: ServiceEditState()));
    expect(find.text('Layanan baru'), findsOneWidget);
    expect(find.text('Rp0/kg'), findsOneWidget);
  });
  testWidgets('ServiceTypeSection maps kiloan/satuan to original callback indices', (tester) async {
    int? selected;
    await pumpServiceSection(
      tester,
      ServiceTypeSection(kind: ServiceKind.kiloan, onKind: (value) => selected = value),
    );
    await tester.tap(find.widgetWithText(SelectionTile, 'Satuan'));
    expect(selected, 1);
    await tester.tap(find.widgetWithText(SelectionTile, 'Kiloan'));
    expect(selected, 0);
  });
}
