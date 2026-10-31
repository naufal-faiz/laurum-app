import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/proposals/state/whatsapp_link.dart';
import 'package:laurum/features/proposals/widgets/ai_connection_section.dart';
import 'package:laurum/features/proposals/widgets/ai_preferences_section.dart';
import 'package:laurum/features/proposals/widgets/whatsapp_link_section.dart';
import 'package:laurum/shared/widgets/atoms/app_switch.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

void main() {
  testWidgets('AiPreferencesSection delegates all toggles independently', (tester) async {
    final changed = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AiPreferencesSection(
              value: (readMessages: true, ignoreGroups: true, detectCancellation: true),
              onRead: (_) => changed.add('read'),
              onGroups: (_) => changed.add('groups'),
              onCancellation: (_) => changed.add('cancel'),
            ),
          ),
        ),
      ),
    );
    for (final row in tester.widgetList<ToggleRow>(find.byType(ToggleRow))) {
      final toggle = find.descendant(
        of: find.widgetWithText(ToggleRow, row.label),
        matching: find.byType(AppSwitch),
      );
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
    }
    expect(changed, ['read', 'groups', 'cancel']);
  });
  testWidgets('AiConnectionSection disconnected state offers reconnect only', (tester) async {
    var connects = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AiConnectionSection(
            connected: false,
            phone: '0812-3456-7890',
            onConnect: () => connects++,
            onDisconnect: () {},
            onCheck: () {},
          ),
        ),
      ),
    );
    expect(find.text('Putuskan koneksi'), findsNothing);
    expect(find.text('WhatsApp terputus. Pembacaan pesan dijeda.'), findsOneWidget);
    await tester.tap(find.text('Hubungkan WhatsApp'));
    expect(connects, 1);
  });
  testWidgets('WhatsappLinkSection expired code offers reload callback', (tester) async {
    var reloads = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: WhatsappLinkSection(
              status: WhatsappLinkStatus.expired,
              onCheck: () {},
              onRefresh: () => reloads++,
              onDone: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Kode kedaluwarsa'), findsOneWidget);
    await tester.ensureVisible(find.text('Muat ulang kode'));
    await tester.tap(find.text('Muat ulang kode'));
    expect(reloads, 1);
  });
}
