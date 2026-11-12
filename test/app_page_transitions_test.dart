import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_page_transitions.dart';
import 'package:laurum/core/theme/app_theme.dart';

void main() {
  test('android opens pages with the incoming-only transition', () {
    final builders = AppTheme.light.pageTransitionsTheme.builders;

    expect(builders[TargetPlatform.android], isA<AppPageTransitionsBuilder>());
  });

  testWidgets('a pushed page fades in over the page already painted', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        navigatorKey: navigator,
        home: const Scaffold(body: Text('Halaman lama')),
      ),
    );

    navigator.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('Halaman baru'))),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    expect(find.text('Halaman lama'), findsOneWidget);
    expect(
      find.ancestor(of: find.text('Halaman lama'), matching: find.byType(FadeTransition)),
      findsNothing,
    );
    final fades = tester.widgetList<FadeTransition>(
      find.ancestor(of: find.text('Halaman baru'), matching: find.byType(FadeTransition)),
    );
    expect(fades.any((fade) => fade.opacity.value < 1), isTrue);

    await tester.pumpAndSettle();
    expect(find.text('Halaman lama'), findsNothing);
    expect(find.text('Halaman baru'), findsOneWidget);
  });
}
