import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/device_external_launcher.dart';
import 'package:laurum/core/services/receipt_document_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const receipt = ReceiptDocumentData(
    title: 'Laundry',
    header: [],
    groups: [
      [ReceiptDocumentRow('No. HP', '-')],
    ],
    status: 'Pembayaran lunas',
    settled: true,
    footer: [],
    fileName: 'struk-A-1',
  );
  tearDown(() => messenger.setMockMethodCallHandler(DeviceExternalLauncher.channel, null));

  test('Android preserves app settings action used by contact permission recovery', () async {
    messenger.setMockMethodCallHandler(DeviceExternalLauncher.channel, (call) async {
      expect(call.method, 'settings');
      return true;
    });
    expect(await DeviceExternalLauncher(android: true).launchUrl('app-settings:'), isTrue);
  });

  test('Android shares a readable PNG and caption, with optional recipient', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(DeviceExternalLauncher.channel, (call) async {
      calls.add(call);
      return true;
    });
    final launcher = DeviceExternalLauncher(android: true);
    for (final phone in ['', '+62 812-3456-7890']) {
      expect(
        await launcher.launchWhatsApp(phone: phone, message: 'Struk A-1', receipt: receipt),
        isTrue,
      );
    }
    final first = calls.first.arguments as Map<Object?, Object?>;
    final last = calls.last.arguments as Map<Object?, Object?>;
    expect(first['phone'], '');
    expect(last['phone'], '6281234567890');
    expect(last['message'], 'Struk A-1');
    final codec = await ui.instantiateImageCodec(last['image'] as Uint8List);
    final frame = await codec.getNextFrame();
    expect(frame.image.width, 640);
    expect(frame.image.height, greaterThan(100));
    frame.image.dispose();
    codec.dispose();
  });

  test('empty phone opens WhatsApp recipient selection; platform failures return false', () async {
    final launcher = DeviceExternalLauncher(android: true);
    messenger.setMockMethodCallHandler(DeviceExternalLauncher.channel, (call) async {
      final args = call.arguments as Map<Object?, Object?>;
      expect(args['phone'], '');
      expect(args['image'], isNull);
      return true;
    });
    expect(await launcher.launchWhatsApp(phone: '', message: ''), isTrue);
    messenger.setMockMethodCallHandler(DeviceExternalLauncher.channel, (_) async {
      throw PlatformException(code: 'unavailable');
    });
    expect(await launcher.launchWhatsApp(phone: '', message: ''), isFalse);
  });
}
