import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/export_service.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/photo_picker.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/sync_service.dart';

void main() {
  group('Fake Platform Services', () {
    test('FakePrintService records printed text', () async {
      final service = FakePrintService();
      expect(service.isConnected, true);
      final ok = await service.printReceipt('Struk Laurum');
      expect(ok, true);
      expect(service.printedReceipts, ['Struk Laurum']);
    });

    test('FakeExternalLauncher records WhatsApp and URL calls', () async {
      final launcher = FakeExternalLauncher();
      await launcher.launchWhatsApp(phone: '08123456789', message: 'Halo');
      await launcher.launchUrl('https://laurum.app');
      expect(launcher.whatsAppCalls.length, 1);
      expect(launcher.whatsAppCalls.first.phone, '08123456789');
      expect(launcher.launchedUrls, ['https://laurum.app']);
    });

    test('FakeContactSource returns fixture contacts and logs call', () async {
      final source = FakeContactSource();
      final contacts = await source.getContacts();
      expect(contacts.length, 4);
      expect(contacts.first.name, 'Agus Pratama');
      expect(source.getContactsCallCount, 1);
    });

    test('FakePhotoPicker logs calls and returns default path', () async {
      final picker = FakePhotoPicker();
      final path = await picker.pickPhoto();
      expect(path, 'assets/photos/sample_expense.jpg');
      expect(picker.pickPhotoCallCount, 1);
    });

    test('FakeExportService logs exports', () async {
      final exporter = FakeExportService();
      final res = await exporter.exportReport(fileName: 'rep.csv', content: 'a,b');
      expect(res, '/dummy/exports/rep.csv');
      expect(exporter.exportedReports.length, 1);
    });

    test('FakeAuthService logs sign in, sign out, delete account', () async {
      final auth = FakeAuthService();
      expect(auth.isSignedIn, true);
      await auth.signOut();
      expect(auth.isSignedIn, false);
      await auth.signInWithGoogle();
      expect(auth.isSignedIn, true);
      await auth.deleteAccount();
      expect(auth.isSignedIn, false);
      expect(auth.authActionLogs, ['signOut', 'signInWithGoogle', 'deleteAccount']);
    });

    test('FakeSyncService emits status transitions and logs calls', () async {
      final sync = FakeSyncService();
      expect(sync.currentStatus, SyncServiceStatus.tersimpan);
      await sync.syncNow();
      expect(sync.syncCallCount, 1);
      expect(sync.currentStatus, SyncServiceStatus.tersimpan);
      sync.dispose();
    });
  });
}
