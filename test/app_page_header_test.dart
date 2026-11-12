import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/atoms/app_icon_button.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/organisms/app_page_header.dart';

void main() {
  for (final width in [320.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final status in SyncState.values) {
        testWidgets('header grows naturally at $width/$scale/$status', (tester) async {
          var taps = 0;
          tester.view.physicalSize = Size(width, 1000);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              home: Scaffold(
                body: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Column(
                    children: [
                      AppPageHeader(
                        title: 'Judul halaman panjang yang dapat diganti',
                        subtitle: 'Subjudul panjang tetap terlihat lengkap ketika teks diperbesar dan status berada pada baris berikutnya.',
                        action: AppIconButton(
                          icon: AppIcons.search,
                          label: 'Cari',
                          onPressed: () => taps++,
                        ),
                        status: SyncIndicator(state: status),
                      ),
                      const Expanded(child: Text('Isi halaman')),
                    ],
                  ),
                ),
              ),
            ),
          );
          expect(find.text('LAURUM'), findsOneWidget);
          expect(find.text('Isi halaman'), findsOneWidget);
          expect(tester.getSize(find.byType(AppPageHeader)).height, greaterThan(80));
          expect(tester.takeException(), isNull);
          await tester.tap(find.byTooltip('Cari'));
          expect(taps, 1);
        });
      }
    }
  }
}
