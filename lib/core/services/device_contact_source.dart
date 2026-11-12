import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:laurum/core/services/contact_source.dart';

/// Reads the phone address book through the system contacts API.
///
/// Only the display name and phone numbers are read; email, address and photo
/// never leave this class, and nothing is stored unless the user saves it.
class DeviceContactSource implements ContactSource {
  DeviceContactSource({
    Future<bool> Function()? requestRead,
    Future<List<Contact>> Function()? fetch,
  }) : _requestRead = requestRead ?? _askReadPermission,
       _fetch = fetch ?? _loadContacts;

  final Future<bool> Function() _requestRead;
  final Future<List<Contact>> Function() _fetch;

  @override
  Future<List<ContactItem>> getContacts() async {
    if (!await _requestRead()) throw const ContactPermissionDenied();
    final contacts = await _fetch();
    final seen = <String>{};
    final items = <ContactItem>[];
    for (final contact in contacts) {
      final name = _nameOf(contact);
      if (name.isEmpty) continue;
      for (final phone in contact.phones) {
        final digits = phone.number.replaceAll(RegExp('[^0-9]'), '');
        if (digits.isEmpty || !seen.add(digits)) continue;
        items.add(ContactItem(name: name, phone: phone.number.trim()));
      }
    }
    return items;
  }
}

String _nameOf(Contact contact) {
  final display = contact.displayName?.trim() ?? '';
  if (display.isNotEmpty) return display;
  final name = contact.name;
  return [
    name?.first,
    name?.middle,
    name?.last,
  ].whereType<String>().map((part) => part.trim()).where((part) => part.isNotEmpty).join(' ');
}

Future<bool> _askReadPermission() async {
  final status = await FlutterContacts.permissions.request(PermissionType.read);
  return status == PermissionStatus.granted || status == PermissionStatus.limited;
}

Future<List<Contact>> _loadContacts() => FlutterContacts.getAll(
  properties: {ContactProperty.name, ContactProperty.phone},
);
