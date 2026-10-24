class ContactItem {
  const ContactItem({required this.name, required this.phone});
  final String name;
  final String phone;
}

abstract class ContactSource {
  Future<List<ContactItem>> getContacts();
}

class ContactPermissionDenied implements Exception {
  const ContactPermissionDenied();
}

class FakeContactSource implements ContactSource {
  FakeContactSource({
    List<ContactItem> contacts = const [],
    this.permissionDenied = false,
  }) : _contacts = List.unmodifiable(contacts);

  final List<ContactItem> _contacts;
  final bool permissionDenied;
  int getContactsCallCount = 0;

  @override
  Future<List<ContactItem>> getContacts() async {
    getContactsCallCount++;
    if (permissionDenied) throw const ContactPermissionDenied();
    return List.unmodifiable(_contacts);
  }
}
