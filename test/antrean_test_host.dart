import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/app.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/main_dummy.dart';

Future<({ProviderContainer container, GoRouter router})> pumpAntrean(
  WidgetTester tester, {
  ProviderContainer? container,
  String location = '/antrean',
  bool settle = true,
  double textScale = 1,
}) async {
  for (final font in {
    'Plus Jakarta Sans': 'assets/fonts/PlusJakartaSans.ttf',
    'IBM Plex Mono': 'assets/fonts/IBMPlexMono-Regular.ttf',
    'packages/ionicons/Ionicons': 'packages/ionicons/assets/fonts/Ionicons.ttf',
  }.entries) {
    await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
  }
  final scope = container ?? ProviderContainer(overrides: dummyRepositoryOverrides);
  final router = createAppRouter(initialLocation: location);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    scope.dispose();
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: scope,
      child: MediaQuery.fromView(
        view: tester.view,
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
            child: RepaintBoundary(
              key: const ValueKey('antrean-golden'),
              child: LaurumApp(router: router),
            ),
          ),
        ),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return (container: scope, router: router);
}
