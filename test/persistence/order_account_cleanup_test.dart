import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/features/auth/state/auth_session.dart';

import 'b1d_commands.dart';
import 'b1d_harness.dart';

void main() {
  for (final table in [
    'payments',
    'order_events',
    'order_items',
    'orders',
    'customers',
    'services',
    'outbox',
    'local_settings',
  ]) {
    test('account cleanup restores SQL and auth when deleting $table fails', () async {
      final h = B1dHarness();
      addTearDown(h.close);
      await h.seed();
      await checkout(h, term: PayTerm.sekarang, received: 1000);
      expect(await h.orders.getAllPayments(), hasLength(1));
      final before = await h.snapshot();
      await h.fail(table, action: 'DELETE');
      final auth = h.scope.read(authSessionProvider.notifier);
      expect(await auth.deleteAccount(), isFalse);
      expect(h.auth.isSignedIn, isTrue);
      expect(await h.snapshot(), before);
      await h.db.customStatement('DROP TRIGGER injected');
      expect(await auth.deleteAccount(), isTrue);
      expect(h.auth.isSignedIn, isFalse);
      expect((await h.snapshot()).values, everyElement(isEmpty));
      expect(await h.scope.read(proposalRepositoryProvider).getProposals(), isEmpty);
    });
  }
}
