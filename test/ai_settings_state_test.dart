import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/features/proposals/state/ai_settings.dart';
import 'package:laurum/features/proposals/state/whatsapp_link.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

void main() {
  test('AI preferences toggle independently and persist in provider scope', () {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    final actions = scope.read(aiSettingsProvider.notifier);
    actions.readMessages(enabled: false);
    expect(scope.read(aiSettingsProvider).readMessages, isFalse);
    expect(scope.read(aiSettingsProvider).ignoreGroups, isTrue);
    actions.ignoreGroups(enabled: false);
    actions.detectCancellation(enabled: false);
    expect(scope.read(aiSettingsProvider).detectCancellation, isFalse);
    expect(scope.read(aiSettingsProvider).ignoreGroups, isFalse);
    actions.readMessages(enabled: true);
    expect(scope.read(aiSettingsProvider).readMessages, isTrue);
  });
  testWidgets('QR expires, refreshes, connects and cancels expiry timer', (tester) async {
    final scope = ProviderContainer();
    addTearDown(scope.dispose);
    scope.read(whatsappConnectionProvider.notifier).setConnected(connected: false);
    final keepAlive = scope.listen(whatsappLinkProvider, (_, _) {});
    addTearDown(keepAlive.close);
    expect(scope.read(whatsappLinkProvider), WhatsappLinkStatus.waiting);
    await tester.pump(const Duration(minutes: 1));
    expect(scope.read(whatsappLinkProvider), WhatsappLinkStatus.expired);
    scope.read(whatsappLinkProvider.notifier).check();
    expect(scope.read(whatsappConnectionProvider), isFalse);
    scope.read(whatsappLinkProvider.notifier).refresh();
    expect(scope.read(whatsappLinkProvider), WhatsappLinkStatus.waiting);
    scope.read(whatsappLinkProvider.notifier).check();
    expect(scope.read(whatsappConnectionProvider), isTrue);
    expect(scope.read(whatsappLinkProvider), WhatsappLinkStatus.connected);
    await tester.pump(const Duration(minutes: 1));
    expect(scope.read(whatsappLinkProvider), WhatsappLinkStatus.connected);
  });
}
