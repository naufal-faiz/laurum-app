import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/shell/state/shell_state.dart';

enum WhatsappLinkStatus { waiting, connected, expired }

class WhatsappLink extends Notifier<WhatsappLinkStatus> {
  Timer? _expiry;
  @override
  WhatsappLinkStatus build() {
    ref.onDispose(() => _expiry?.cancel());
    if (ref.read(whatsappConnectionProvider)) return WhatsappLinkStatus.connected;
    _scheduleExpiry();
    return WhatsappLinkStatus.waiting;
  }

  void _scheduleExpiry() {
    _expiry?.cancel();
    _expiry = Timer(const Duration(minutes: 1), () => state = WhatsappLinkStatus.expired);
  }

  void refresh() {
    state = WhatsappLinkStatus.waiting;
    _scheduleExpiry();
  }

  void check() {
    if (state == WhatsappLinkStatus.expired) return;
    _expiry?.cancel();
    ref.read(whatsappConnectionProvider.notifier).setConnected(connected: true);
    state = WhatsappLinkStatus.connected;
  }
}

final whatsappLinkProvider = NotifierProvider.autoDispose<WhatsappLink, WhatsappLinkStatus>(
  WhatsappLink.new,
);
