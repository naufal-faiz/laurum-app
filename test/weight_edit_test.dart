import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/transactions/pages/weight_input_sheet.dart';
import 'package:laurum/features/transactions/state/transaction_draft.dart';
import 'package:laurum/features/transactions/state/weight_edit.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_numpad_key.dart';

import 'keyboard_test_helper.dart';

void main() {
  late ProviderContainer container;
  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  DraftLine lineFor(ServiceKind kind) => container
      .read(transactionDraftProvider)
      .lines
      .firstWhere((line) => line.service.kind == kind);

  DraftLine seed(ServiceKind kind) {
    final service = serviceFixtures.firstWhere((item) => item.kind == kind);
    container.read(transactionDraftProvider.notifier).add(service);
    return lineFor(kind);
  }

  test('start menandai fresh dengan nilai awal 1 kg atau 1 pcs', () {
    final kilo = seed(ServiceKind.kiloan);
    container.read(weightEditProvider.notifier).start(kilo);
    final kiloState = container.read(weightEditProvider);
    expect(kiloState.text, '1');
    expect(kiloState.milli, 1000);
    expect(kiloState.fresh, isTrue);

    final satuan = seed(ServiceKind.satuan);
    container.read(weightEditProvider.notifier).start(satuan);
    final satuanState = container.read(weightEditProvider);
    expect(satuanState.text, '1');
    expect(satuanState.milli, 1000);
  });

  test('ketukan angka pertama mengganti nilai awal', () {
    final line = seed(ServiceKind.kiloan);
    final edit = container.read(weightEditProvider.notifier)..start(line);
    edit.key(AppNumpadKeyValue.five);
    final state = container.read(weightEditProvider);
    expect(state.text, '5');
    expect(state.milli, 5000);
    expect(state.fresh, isFalse);
  });

  test('koma pertama menjadi 0, dan backspace pada fresh mengosongkan', () {
    final line = seed(ServiceKind.kiloan);
    final edit = container.read(weightEditProvider.notifier)..start(line);
    edit.key(AppNumpadKeyValue.decimal);
    expect(container.read(weightEditProvider).text, '0,');
    expect(container.read(weightEditProvider).milli, 0);

    edit.key(AppNumpadKeyValue.backspace);
    expect(container.read(weightEditProvider).text, '');
    expect(container.read(weightEditProvider).milli, 0);

    edit.key(AppNumpadKeyValue.three);
    edit.key(AppNumpadKeyValue.backspace);
    expect(container.read(weightEditProvider).text, '');
    expect(container.read(weightEditProvider).milli, 0);
  });

  test('tanpa nol di depan dan tidak mengklam nilai di bawah minimum', () {
    final line = seed(ServiceKind.kiloan);
    final edit = container.read(weightEditProvider.notifier)..start(line);
    edit.key(AppNumpadKeyValue.zero);
    edit.key(AppNumpadKeyValue.decimal);
    edit.key(AppNumpadKeyValue.three);
    final state = container.read(weightEditProvider);
    expect(state.text, '0,3');
    expect(state.milli, 300);

    edit.key(AppNumpadKeyValue.backspace);
    edit.key(AppNumpadKeyValue.backspace);
    edit.key(AppNumpadKeyValue.zero);
    edit.key(AppNumpadKeyValue.five);
    expect(container.read(weightEditProvider).text, '5');
  });

  test('chip menambah ke nilai saat ini tanpa klamp dan mematikan fresh', () {
    final line = seed(ServiceKind.kiloan);
    final edit = container.read(weightEditProvider.notifier)..start(line);
    edit.add(500);
    final state = container.read(weightEditProvider);
    expect(state.text, '1,5');
    expect(state.milli, 1500);
    expect(state.fresh, isFalse);

    edit.add(5000);
    expect(container.read(weightEditProvider).text, '6,5');
  });

  test('pcs mengabaikan koma', () {
    final line = seed(ServiceKind.satuan);
    final edit = container.read(weightEditProvider.notifier)..start(line);
    edit.key(AppNumpadKeyValue.decimal);
    expect(container.read(weightEditProvider).text, '1');
    edit.key(AppNumpadKeyValue.five);
    expect(container.read(weightEditProvider).text, '5');
  });

  testWidgets('sheet berat: angka mengganti, nilai 0,3 menampilkan error dan simpan nonaktif', (
    tester,
  ) async {
    configureKeyboardTest(tester);
    final line = seed(ServiceKind.kiloan);
    await pumpWeightHost(tester, container, line.service.id);
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    expect(find.text('1 kg'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text('5 kg'), findsOneWidget);
    await tester.tap(find.text('Simpan berat'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 5000);

    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0'));
    await tester.pump();
    await tester.tap(find.text(','));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(find.text('0,3 kg'), findsOneWidget);
    expect(find.text('Minimal 0,5 kg'), findsOneWidget);
    final save = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Simpan berat'));
    expect(save.onPressed, isNull);
    await tester.tap(find.text('Simpan berat'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 5000);
  });

  testWidgets('sheet berat: chip menambah nilai', (tester) async {
    configureKeyboardTest(tester);
    final line = seed(ServiceKind.kiloan);
    await pumpWeightHost(tester, container, line.service.id);
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+0,5 kg'));
    await tester.pump();
    expect(find.text('1,5 kg'), findsOneWidget);
    await tester.tap(find.text('Simpan berat'));
    await tester.pumpAndSettle();
    expect(container.read(transactionDraftProvider).lines.single.qtyMilli, 1500);
  });
}

Future<void> pumpWeightHost(
  WidgetTester tester,
  ProviderContainer container,
  String serviceId,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light,
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: Center(
              child: AppButton(
                'Buka',
                onPressed: () => WeightInputSheet.show(context, ref, serviceId),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
