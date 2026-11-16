import 'dart:async';

import 'package:laurum/core/services/sync_service.dart';

class HeldRefreshSync extends FakeSyncService {
  final gate = Completer<void>();
  int requests = 0;
  bool ready = true;
  @override
  bool get canSync => ready;
  @override
  Future<void> syncNow() async {
    requests++;
    await gate.future;
    await super.syncNow();
  }
}
