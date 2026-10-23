class ContactItem {
  const ContactItem({required this.name, required this.phone});
  final String name;
  final String phone;
}

abstract class ContactSource {
  Future<List<ContactItem>> getContacts();
}

class FakeContactSource implements ContactSource {
  FakeContactSource({List<ContactItem> contacts = const []})
    : _contacts = List.unmodifiable(contacts);

  final List<ContactItem> _contacts;
  int getContactsCallCount = 0;

  @override
  Future<List<ContactItem>> getContacts() async {
    getContactsCallCount++;
    return List.unmodifiable(_contacts);
  }
}
