import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/sync_service.dart';

final businessClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
final businessProfileProvider = FutureProvider(
  (ref) => ref.watch(businessRepositoryProvider).getProfile(),
);
final shellSyncProvider = StreamProvider<SyncServiceStatus>((ref) async* {
  final service = ref.watch(syncServiceProvider);
  yield service.currentStatus;
  yield* service.statusStream;
});
final whatsappConnectionProvider = NotifierProvider<FakeWhatsappConnection, bool>(
  FakeWhatsappConnection.new,
);

class FakeWhatsappConnection extends Notifier<bool> {
  @override
  bool build() => true;
  void setConnected({required bool connected}) => state = connected;
}
