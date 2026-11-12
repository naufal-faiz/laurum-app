import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

void main() {
  Widget host(int index, {VoidCallback? onTap}) => MaterialApp(
    theme: AppTheme.light,
    home: RootScaffold(
      title: 'Usaha',
      accountLabel: 'Akun',
      activeIndex: index,
      body: Center(child: AppButton('Aksi isi', onPressed: onTap ?? () {})),
    ),
  );

  testWidgets('switching tabs paints the new tab without a covering fade', (tester) async {
    await tester.pumpWidget(host(0));
    await tester.pumpAndSettle();

    await tester.pumpWidget(host(1));

    expect(find.byKey(const ValueKey('tab-fade-1')), findsNothing);
    expect(
      find.descendant(of: find.byType(RootScaffold), matching: find.byType(Opacity)),
      findsNothing,
    );
    expect(find.text('Aksi isi'), findsOneWidget);
  });

  testWidgets('new tab is tappable on the first frame', (tester) async {
    var taps = 0;
    void tap() => taps++;
    await tester.pumpWidget(host(0, onTap: tap));
    await tester.pumpAndSettle();

    await tester.pumpWidget(host(1, onTap: tap));
    await tester.tap(find.text('Aksi isi'));

    expect(taps, 1);
  });
}
