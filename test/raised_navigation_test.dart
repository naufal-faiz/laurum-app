import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/organisms/bottom_nav_bar.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

void main() {
  testWidgets('floating nav leaves page taps and scroll clear of the create action', (
    tester,
  ) async {
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
    final nav = tester.getRect(find.byType(BottomNavBar));
    final circle = tester.getRect(
      find.descendant(of: find.byType(BottomNavBar), matching: find.byType(InkWell)),
    );
    final page = tester.getRect(find.byType(ListView));
    expect(page.bottom, greaterThan(nav.top));
    expect(page.bottom, lessThan(circle.bottom));
    for (final point in [
      Offset(20, page.bottom - 5),
      Offset(780, page.bottom - 5),
    ]) {
      await tester.tapAt(point);
    }
    expect(taps, 2);
    expect(creates, 0);
    await tester.dragFrom(Offset(20, page.bottom - 5), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(scroll.offset, greaterThan(0));
    await tester.tapAt(circle.center);
    expect(creates, 1);
  });
}
