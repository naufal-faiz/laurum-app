String customerPhoneKey(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('62')) return '0${digits.substring(2)}';
  if (digits.startsWith('8')) return '0$digits';
  return digits;
}

String customerNameKey(String value) => value.trim().toLowerCase();

String customerPhonePrefix(String query) =>
    RegExp(r'^[+\d\s().-]+$').hasMatch(query.trim()) ? customerPhoneKey(query) : '';

bool matchesCustomerPrefix(String name, String phone, String query) {
  final key = customerNameKey(query), digits = customerPhonePrefix(query);
  return key.isEmpty ||
      customerNameKey(name).startsWith(key) ||
      (digits.isNotEmpty && customerPhoneKey(phone).startsWith(digits));
}
