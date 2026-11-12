import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/core/services/device_contact_source.dart';

void main() {
  test('maps name and phone, skips unusable and duplicate numbers', () async {
    var fetched = 0;
    final source = DeviceContactSource(
      requestRead: () async => true,
      fetch: () async {
        fetched++;
        return const [
          Contact(
            displayName: 'Ani',
            phones: [
              Phone(number: '0812-3456'),
              Phone(number: '08123456'),
            ],
          ),
          Contact(
            displayName: 'Budi',
            phones: [Phone(number: '  ')],
          ),
          Contact(
            name: Name(first: 'Citra', last: 'Dewi'),
            phones: [Phone(number: '0813')],
          ),
          Contact(
            displayName: '  ',
            phones: [Phone(number: '0814')],
          ),
        ];
      },
    );

    final items = await source.getContacts();

    expect(fetched, 1);
    expect(items.map((item) => '${item.name}|${item.phone}'), ['Ani|0812-3456', 'Citra Dewi|0813']);
  });

  test('denied permission throws without reading contacts', () async {
    var fetched = false;
    final source = DeviceContactSource(
      requestRead: () async => false,
      fetch: () async {
        fetched = true;
        return const [];
      },
    );

    await expectLater(source.getContacts(), throwsA(isA<ContactPermissionDenied>()));
    expect(fetched, isFalse);
  });
}
