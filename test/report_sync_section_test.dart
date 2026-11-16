import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/features/reports/widgets/report_sync_section.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

void main() {
  testWidgets('report keeps offline and failure feedback outside root shell', (tester) async {
    for (final status in SyncServiceStatus.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ReportSyncSection(status: status)),
        ),
      );
      expect(
        find.byType(BannerMessage),
        status == SyncServiceStatus.offline || status == SyncServiceStatus.gagal
            ? findsOneWidget
            : findsNothing,
      );
    }
  });
}
