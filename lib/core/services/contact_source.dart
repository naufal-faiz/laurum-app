class ContactItem {
  const ContactItem({required this.name, required this.phone});
  final String name;
  final String phone;
}

abstract class ContactSource {
  Future<List<ContactItem>> getContacts();
}

class FakeContactSource implements ContactSource {
  FakeContactSource({List<ContactItem>? contacts})
    : _contacts =
          contacts ??
          const [
            ContactItem(name: 'Agus Pratama', phone: '0856-4400-1234'),
            ContactItem(name: 'Danang Kos Putri', phone: '0857-2201-3344'),
            ContactItem(name: 'Mbak Maya Laundry', phone: '0878-9900-1122'),
            ContactItem(name: 'Siti Rohmah', phone: '0821-4455-6677'),
          ];

  final List<ContactItem> _contacts;
  int getContactsCallCount = 0;

  @override
  Future<List<ContactItem>> getContacts() async {
    getContactsCallCount++;
    return List.unmodifiable(_contacts);
  }
}
