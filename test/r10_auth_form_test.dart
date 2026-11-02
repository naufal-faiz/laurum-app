import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/main_dummy.dart';

class FailingPasswordAuth extends FakeAuthService {
  FailingPasswordAuth() : super(isSignedIn: false);
  @override
  Future<bool> signInWithPassword(String email, String password) async =>
      throw Exception('server echoed $password');
}

void main() {
  test('form secrets never enter UI snapshot, failure error, or logs', () async {
    final auth = FailingPasswordAuth();
    final scope = ProviderContainer(overrides: dummyOverrides(authService: auth));
    addTearDown(scope.dispose);
    final provider = authFormProvider(AuthFormKind.signIn);
    final listener = scope.listen(provider, (_, _) {});
    addTearDown(listener.close);
    final form = scope.read(provider.notifier);
    form.email('ratna@example.com');
    form.secret(AuthSecret.password, 'DO-NOT-LOG-123');
    expect(await form.submit(), isFalse);
    final view = scope.read(provider);
    expect(view.error, isNot(contains('DO-NOT-LOG')));
    expect(view.errors.values.join(), isNot(contains('DO-NOT-LOG')));
    expect(view.toString(), isNot(contains('DO-NOT-LOG')));
    scope.invalidate(provider);
    expect(await scope.read(provider.notifier).submit(), isFalse);
    expect(scope.read(provider).errors['password'], isNotNull);
  });
  test('request limit is shown without raw exception text', () async {
    final scope = ProviderContainer(
      overrides: dummyOverrides(authService: FakeAuthService(isSignedIn: false, rateLimited: true)),
    );
    addTearDown(scope.dispose);
    final provider = authFormProvider(AuthFormKind.signIn);
    final listener = scope.listen(provider, (_, _) {});
    addTearDown(listener.close);
    final form = scope.read(provider.notifier);
    form.email('ratna@example.com');
    form.secret(AuthSecret.password, 'Laundry123!');
    expect(await form.submit(), isFalse);
    expect(scope.read(provider).error, 'Terlalu banyak percobaan. Coba lagi nanti');
    expect(const AuthFailure(AuthFailureKind.requestLimit).toString(), isNot(contains('Laundry')));
  });
}
