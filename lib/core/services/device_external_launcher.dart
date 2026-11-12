import 'dart:io';

import 'package:flutter/services.dart';
import 'package:laurum/core/services/external_launcher.dart';
import 'package:laurum/core/services/receipt_document_data.dart';
import 'package:laurum/core/services/receipt_png.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

String whatsAppPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  return digits.replaceFirst(RegExp('^0'), '62');
}

class DeviceExternalLauncher implements ExternalLauncher {
  DeviceExternalLauncher({bool? android}) : _android = android ?? Platform.isAndroid;
  final bool _android;
  static const channel = MethodChannel('laurum/whatsapp');

  @override
  Future<bool> launchWhatsApp({
    required String phone,
    required String message,
    ReceiptDocumentData? receipt,
  }) async {
    try {
      final number = whatsAppPhone(phone);
      final image = receipt == null ? null : await receiptPng(receipt);
      if (_android && (image != null || number.isEmpty)) {
        return await channel.invokeMethod<bool>('share', {
              'phone': number,
              'message': message,
              'image': image,
            }) ??
            false;
      }
      if (image == null && number.isEmpty && message.isEmpty) {
        return await launcher.launchUrl(
          Uri.parse('whatsapp://'),
          mode: launcher.LaunchMode.externalApplication,
        );
      }
      if (image != null || number.isEmpty) {
        // iOS share extensions choose the recipient inside WhatsApp.
        final result = await SharePlus.instance.share(
          ShareParams(
            text: message.isEmpty ? null : message,
            files: image == null ? null : [XFile.fromData(image, mimeType: 'image/png')],
            fileNameOverrides: image == null ? null : ['struk.png'],
            sharePositionOrigin: const Rect.fromLTWH(1, 1, 1, 1),
          ),
        );
        return result.status != ShareResultStatus.dismissed;
      }
      return await launcher.launchUrl(
        Uri(
          scheme: 'https',
          host: 'wa.me',
          path: number,
          queryParameters: message.isEmpty ? null : {'text': message},
        ),
        mode: launcher.LaunchMode.externalApplication,
      );
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> launchUrl(String url) async {
    try {
      if (_android && url == 'app-settings:') {
        return await channel.invokeMethod<bool>('settings') ?? false;
      }
      return await launcher.launchUrl(
        Uri.parse(url),
        mode: launcher.LaunchMode.externalApplication,
      );
    } on Object {
      return false;
    }
  }
}
