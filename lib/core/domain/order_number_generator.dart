class OrderNumberGenerator {
  const OrderNumberGenerator({this.deviceCode = 'A'});
  final String deviceCode;

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
