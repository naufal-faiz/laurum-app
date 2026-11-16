import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/data_refresh_failure.dart';
import 'package:laurum/shared/widgets/organisms/app_data_refresh.dart';

void main() {
  for (final scrollable in [true, false]) {
    testWidgets('short content refreshes with font2x, scrollable=$scrollable', (tester) async {
      final gate = Completer<void>();
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: AppDataRefresh(
                hasScrollableChild: scrollable,
                onRefresh: () {
                  calls++;
                  return gate.future;
                },
                child: scrollable
                    ? ListView(children: const [Text('Konten pendek')])
                    : const Center(child: Text('Belum ada data')),
              ),
            ),
          ),
        ),
      );
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 400));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(calls, 1);
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 400));
      await tester.pump();
      expect(calls, 1);
      gate.complete();
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('failure shows safe feedback and keeps existing content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDataRefresh(
            onRefresh: () async => throw DataRefreshFailure.offline,
            child: ListView(children: const [Text('Data lokal')]),
          ),
        ),
      ),
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(find.text('Data lokal'), findsOneWidget);
    expect(find.text(DataRefreshFailure.offline.message), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('leaving during refresh safely ignores late failures', (tester) async {
    final gate = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDataRefresh(
            onRefresh: () => gate.future,
            child: ListView(children: const [Text('Data lokal')]),
          ),
        ),
      ),
    );
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 400));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(const SizedBox.shrink());
    gate.completeError(StateError('sensitive transport failure'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
