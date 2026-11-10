import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

void main() {
  testWidgets('tab fade animates but never blocks actions in the page', (tester) async {
    var taps = 0;
    Widget host(int index) => MaterialApp(
      theme: AppTheme.light,
      home: RootScaffold(
        title: 'Usaha',
        accountLabel: 'Akun',
        activeIndex: index,
        body: Center(child: AppButton('Aksi isi', onPressed: () => taps++)),
      ),
    );
    await tester.pumpWidget(host(0));
    await tester.pumpAndSettle();
    await tester.pumpWidget(host(1));
    final fade = find.descendant(
      of: find.byKey(const ValueKey('tab-fade-1')),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(fade).opacity, greaterThan(0));
    await tester.tap(find.text('Aksi isi'));
    expect(taps, 1);
    await tester.pump(const Duration(milliseconds: 110));
    expect(tester.widget<Opacity>(fade).opacity, inExclusiveRange(0, 1));
    await tester.pump(const Duration(milliseconds: 220));
    expect(tester.widget<Opacity>(fade).opacity, 0);
  });
  testWidgets('reduced motion displays new tab immediately', (tester) async {
    Widget host(int index) => MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: RootScaffold(
          title: 'Usaha',
          accountLabel: 'Akun',
          activeIndex: index,
          body: const Text('Isi'),
        ),
      ),
    );
    await tester.pumpWidget(host(0));
    await tester.pumpWidget(host(1));
    final fade = find.descendant(
      of: find.byKey(const ValueKey('tab-fade-1')),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(fade).opacity, 0);
  });
}
