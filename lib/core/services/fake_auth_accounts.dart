import 'package:laurum/core/services/auth_failure.dart';
import 'package:laurum/core/services/fake_auth_account.dart';

class FakeAuthAccounts {
  FakeAuthAccounts(this.initial, Iterable<FakeAuthAccount> accounts)
    : _records = {for (final account in accounts) account.email.toLowerCase(): account},
      profile = initial {
    profile = _records[initial.email] ?? initial;
    _records.putIfAbsent(initial.email, () => initial);
  }
  final FakeAuthAccount initial;
  Map<String, FakeAuthAccount> _records;
  FakeAuthAccount profile;
  FakeAuthAccount? _pending;
  bool usesPassword = false, awaitingEmail = false;
  void _save(FakeAuthAccount value) {
    profile = value;
    _records[value.email] = value;
  }

  bool login(String email, String password) {
    final account = _records[email.trim().toLowerCase()];
    if (account == null || !account.matchesPassword(password)) return false;
    profile = account;
    usesPassword = true;
    cancelVerification();
    return true;
  }

  void google({required bool needsSetup}) {
    _save(
      (_records[initial.email] ?? initial.copyWith(needsSetup: needsSetup)).copyWith(
        googleLinked: true,
      ),
    );
    usesPassword = false;
    cancelVerification();
  }

  void register(String email, String password, String name) {
    if (password.runes.length < 8) throw const AuthFailure(AuthFailureKind.invalidInput);
    final address = email.trim().toLowerCase();
    _pending = _records.containsKey(address)
        ? null
        : FakeAuthAccount(
            id: 'account-${_records.length + 1}',
            email: address,
            name: name.trim(),
            password: password,
            needsSetup: true,
          );
    awaitingEmail = true;
  }

  bool confirm() {
    final account = _pending;
    if (account == null) return false;
    _save(account);
    usesPassword = true;
    cancelVerification();
    return true;
  }

  void cancelVerification() {
    _pending = null;
    awaitingEmail = false;
  }

  void updateProfile(String name, String phone) =>
      _save(profile.copyWith(name: name.trim(), phone: phone));
  void changePassword(String current, String next) {
    if (!usesPassword || !profile.matchesPassword(current)) {
      throw const AuthFailure(AuthFailureKind.currentPassword);
    }
    if (next.runes.length < 8) throw const AuthFailure(AuthFailureKind.invalidInput);
    _save(profile.copyWith(password: next));
  }

  void finishSetup() => _save(profile.copyWith(needsSetup: false));
  void delete() {
    _records.remove(profile.email);
    profile = initial.copyWith(needsSetup: true);
    cancelVerification();
  }

  void Function() checkpoint() {
    final records = Map.of(_records), active = profile, pending = _pending;
    final password = usesPassword, waiting = awaitingEmail;
    return () {
      _records = Map.of(records);
      profile = active;
      _pending = pending;
      usesPassword = password;
      awaitingEmail = waiting;
    };
  }
}
