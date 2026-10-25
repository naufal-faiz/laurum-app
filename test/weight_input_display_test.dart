import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

import 'keyboard_test_helper.dart';
import 'weight_edit_test.dart' show pumpWeightHost;

void main() {
  testWidgets('input berat mempertahankan koma dan nol desimal selama mengetik', (tester) async {
    configureKeyboardTest(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final service = serviceFixtures.firstWhere((s) => s.kind == ServiceKind.kiloan);
    container.read(transactionDraftProvider.notifier).add(service);
    await pumpWeightHost(tester, container, service.id);
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(','));
    await tester.pump();
    expect(find.text('0, kg'), findsOneWidget);
    expect(find.text('Minimal 0,5 kg'), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Simpan berat')).onPressed,
      isNull,
    );
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('0'));
    await tester.pump();
    expect(find.text('0,50 kg'), findsOneWidget);
    await tester.tap(find.text('Simpan berat'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 500);
  });
}
