import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/features/settings/widgets/settings_account_section.dart';
import 'package:laurum/features/sync/state/sync_view.dart';
import 'package:laurum/features/sync/widgets/sync_status_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('SignInSection Google callback, error and busy restoration', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SignInSection(
            busy: false,
            restoring: false,
            error: 'Coba lagi',
            onGoogle: () => calls++,
          ),
        ),
      ),
    );
    expect(find.text('Coba lagi'), findsOneWidget);
    await tester.tap(find.text('Lanjutkan dengan Google'));
    expect(calls, 1);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SignInSection(busy: true, restoring: true, onGoogle: () => calls++),
        ),
      ),
    );
    expect(find.text('Memulihkan data...'), findsOneWidget);
    expect(
      tester
          .widget<InkWell>(
            find.descendant(of: find.byType(SignInSection), matching: find.byType(InkWell)),
          )
          .onTap,
      isNull,
    );
  });
  testWidgets('SettingsAccountSection email, manage account and destructive logout', (
    tester,
  ) async {
    var deletes = 0;
    var exits = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SettingsAccountSection(
            email: 'ratna@example.com',
            onManage: () => deletes++,
            onLogout: () => exits++,
          ),
        ),
      ),
    );
    expect(find.text('ratna@example.com'), findsOneWidget);
    await tester.tap(find.text('Kelola akun'));
    await tester.tap(find.text('Keluar'));
    expect(deletes, 1);
    expect(exits, 1);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Keluar')).variant,
      AppButtonVariant.destructiveOutline,
    );
  });
  testWidgets('SyncStatusSection shows pending, last sync, conflict and retry', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SyncStatusSection(
              data: SyncView(SyncServiceStatus.gagal, 2, DateTime(2026, 10, 16, 10, 43)),
              busy: false,
              failed: true,
              conflictExample: 'Contoh konflik',
              onSync: () => calls++,
            ),
          ),
        ),
      ),
    );
    expect(find.text('2 perubahan tertunda'), findsOneWidget);
    expect(find.textContaining('10.43 WIB'), findsOneWidget);
    await tester.tap(find.text('Sinkron sekarang'));
    expect(calls, 1);
  });
}
