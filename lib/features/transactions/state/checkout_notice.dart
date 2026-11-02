import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkoutNoticeProvider = NotifierProvider<CheckoutNotice, String?>(CheckoutNotice.new);

class CheckoutNotice extends Notifier<String?> {
  Timer? _timer;
  @override
  String? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void show(String orderNo) {
    _timer?.cancel();
    state = 'Nota $orderNo tersimpan';
    _timer = Timer(const Duration(seconds: 4), () => state = null);
  }
}
