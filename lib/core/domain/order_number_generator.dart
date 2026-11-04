import 'package:laurum/core/domain/repositories/local_settings_repository.dart';

class OrderNumberGenerator {
  const OrderNumberGenerator({this.deviceCode = 'A', this.settings});
  final String deviceCode;
  final LocalSettingsRepository? settings;

  // Called inside TransactionRunner so a failed checkout restores the counter.
  Future<String> reserveOrderNo(Iterable<String> existingOrderNos) async {
    final local = settings;
    if (local == null) throw StateError('Local settings not initialized');
    final code = await local.getString('device_code') ?? deviceCode;
    final generator = OrderNumberGenerator(deviceCode: code);
    final saved = await local.getInt('order_counter_$code') ?? 0;
    final candidate = generator.nextOrderNo(existingOrderNos);
    final highest = generator.parseSequence(candidate)! - 1;
    final sequence = (saved > highest ? saved : highest) + 1;
    final result = generator.format(sequence);
    await local.setInt('order_counter_$code', sequence);
    return result;
  }

  void _validateDevice() {
    if (!RegExp(r'^[A-Z]+$').hasMatch(deviceCode)) {
      throw ArgumentError('Device code must contain uppercase letters');
    }
  }

  String format(int sequence) {
    _validateDevice();
    if (sequence < 1 || sequence > 9999) {
      throw ArgumentError('Sequence must be between 1 and 9999');
    }
    return '$deviceCode-${sequence.toString().padLeft(4, '0')}';
  }

  int? parseSequence(String orderNo) {
    _validateDevice();
    final match = RegExp('^$deviceCode-(\\d{4})\$').firstMatch(orderNo);
    if (match == null) return null;
    final sequence = int.parse(match.group(1)!);
    return sequence == 0 ? null : sequence;
  }

  String nextOrderNo(Iterable<String> existingOrderNos) {
    var maxSequence = 0;
    for (final number in existingOrderNos) {
      final sequence = parseSequence(number);
      if (sequence != null && sequence > maxSequence) maxSequence = sequence;
    }
    return format(maxSequence + 1);
  }
}
