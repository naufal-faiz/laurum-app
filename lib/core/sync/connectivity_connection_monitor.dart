import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:laurum/core/sync/connection_monitor.dart';

/// Reads the radio state from `connectivity_plus`: one value on listen, then
/// changes. The plugin only reports the radio, not whether the server answers.
class ConnectivityConnectionMonitor implements ConnectionMonitor {
  ConnectivityConnectionMonitor({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  late final StreamController<bool> _controller = StreamController<bool>.broadcast(
    onListen: _start,
  );
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  Stream<bool> get onlineChanges => _controller.stream;

  Future<void> _start() async {
    if (_subscription != null) return;
    _subscription = _connectivity.onConnectivityChanged.listen(_emit);
    _emit(await _connectivity.checkConnectivity());
  }

  void _emit(List<ConnectivityResult> results) {
    if (_controller.isClosed) return;
    _controller.add(results.any((result) => result != ConnectivityResult.none));
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
  }
}
