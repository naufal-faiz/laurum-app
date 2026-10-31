import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

void main() {
  testWidgets('raised circle preserves page taps and scroll around its upper half', (tester) async {
    var taps = 0;
    var creates = 0;
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RootScaffold(
          title: 'Antrean',
          accountLabel: 'Akun',
          activeIndex: 0,
          onCreate: () => creates++,
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps++,
              child: ListView(controller: scroll, children: const [SizedBox(height: 2000)]),
            ),
          ),
        ),
      ),
    );
    final circle = tester.getRect(
      find.descendant(of: find.byType(BottomNavBar), matching: find.byType(InkWell)),
    );
    final page = tester.getRect(find.byType(ListView));
    expect(page.bottom, closeTo(circle.center.dy, 0.01));
    for (final point in [
      Offset(20, circle.top + 5),
      Offset(780, circle.top + 5),
      circle.topLeft + const Offset(1, 1),
      circle.topRight + const Offset(-1, 1),
    ]) {
      await tester.tapAt(point);
    }
    expect(taps, 4);
    expect(creates, 0);
    await tester.dragFrom(Offset(20, circle.top + 5), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(scroll.offset, greaterThan(0));
    await tester.tapAt(Offset(circle.center.dx, circle.top + 4));
    expect(creates, 1);
  });
}
