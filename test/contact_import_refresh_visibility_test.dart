import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/core/services/contact_source.dart';
import 'package:laurum/features/customers/state/customer_import_data.dart';
import 'package:laurum/main_dummy.dart';

import 'antrean_test_host.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id_ID'));
  testWidgets('contact remapping preserves the mounted search field and list', (tester) async {
    final changed = Provider<Object>((ref) => Object());
    const data = ContactImportData([
      ContactImportRow(ContactItem(name: 'Agus Pratama', phone: '081234567890'), exists: false),
    ]);
    Future<ContactImportData> result = Future.value(data);
    final scope = ProviderContainer(
      overrides: [
        ...dummyRepositoryOverrides,
        contactImportProvider.overrideWith((ref) {
          ref.watch(changed);
          return result;
        }),
      ],
    );
    await pumpAntrean(tester, location: '/pelanggan/impor', container: scope);
    final field = tester.element(find.byType(TextField));
    final pending = Completer<ContactImportData>();
    result = pending.future;
    scope.invalidate(changed);
    await tester.pump();
    expect(find.text('Agus Pratama'), findsOneWidget);
    expect(tester.element(find.byType(TextField)), same(field));
    pending.complete(data);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
