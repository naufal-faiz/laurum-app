class OrderNumberGenerator {
  const OrderNumberGenerator({this.deviceCode = 'A'});
  final String deviceCode;

  String format(int sequence) {
    if (sequence < 1 || sequence > 9999) {
      throw ArgumentError('Sequence must be between 1 and 9999');
    }
    return '$deviceCode-${sequence.toString().padLeft(4, '0')}';
  }

  int? parseSequence(String orderNo) {
    final match = RegExp('^$deviceCode-(\\d{4})\$').firstMatch(orderNo);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  String nextOrderNo(Iterable<String> existingOrderNos) {
    var maxSeq = 0;
    for (final no in existingOrderNos) {
      final match = RegExp('^$deviceCode-(\\d{4})\$').firstMatch(no);
      if (match != null) {
        final seq = int.tryParse(match.group(1)!) ?? 0;
        if (seq > maxSeq) maxSeq = seq;
      }
    }
    return format(maxSeq + 1);
  }
}
