import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/export_service.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/photo_picker.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/sync_service.dart';

final printServiceProvider = Provider<PrintService>((ref) {
  return FakePrintService();
});

final externalLauncherProvider = Provider<ExternalLauncher>((ref) {
  return FakeExternalLauncher();
});

final contactSourceProvider = Provider<ContactSource>((ref) {
  return FakeContactSource();
});

final photoPickerProvider = Provider<PhotoPicker>((ref) {
  return FakePhotoPicker();
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return FakeExportService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return FakeAuthService();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = FakeSyncService();
  ref.onDispose(service.dispose);
  return service;
});
