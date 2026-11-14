import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/services/state/service_edit_state.dart';
import 'package:laurum/features/services/widgets/service_duration_section.dart';
import 'package:laurum/shared/widgets/atoms/app_chip.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/molecules/chip_bar.dart';

import 'service_create_test_host.dart';

void main() {
  testWidgets('ServiceDurationSection preserves five choices, day offset and busy toggle', (
    tester,
  ) async {
    int? duration;
    bool? active;
    await pumpServiceSection(
      tester,
      ServiceDurationSection(
        state: const ServiceEditState(),
        onDuration: (value) => duration = value,
        onActive: (value) => active = value,
      ),
    );
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 1);
    await tester.tap(find.widgetWithText(AppChip, '5 hari'));
    expect(duration, 5);
    await tester.tap(find.byType(AppSwitch));
    expect(active, isFalse);
    await pumpServiceSection(
      tester,
      ServiceDurationSection(
        state: const ServiceEditState(busy: true, durationDays: 3, isActive: false),
        onDuration: (_) {},
        onActive: (_) {},
      ),
    );
    expect(tester.widget<ChipBar>(find.byType(ChipBar)).selectedIndex, 2);
    expect(tester.widget<AppSwitch>(find.byType(AppSwitch)).onChanged, isNull);
  });
}
