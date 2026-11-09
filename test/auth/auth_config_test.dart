import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/auth_config.dart';

void main() {
  const key = 'sb_publishable_example';
  test('only complete https (or localhost http) configuration is usable', () {
    expect(
      const AuthConfig(
        supabaseUrl: 'https://x.supabase.co',
        publishableKey: key,
        googleWebClientId: '',
      ).canUseSupabase,
      isTrue,
    );
    expect(
      const AuthConfig(
        supabaseUrl: 'http://x.supabase.co',
        publishableKey: key,
        googleWebClientId: '',
      ).canUseSupabase,
      isFalse,
    );
    expect(
      const AuthConfig(
        supabaseUrl: 'http://127.0.0.1:54321',
        publishableKey: key,
        googleWebClientId: '',
      ).canUseSupabase,
      isTrue,
    );
    expect(
      const AuthConfig(
        supabaseUrl: 'https://x.supabase.co',
        publishableKey: '',
        googleWebClientId: '',
      ).canUseSupabase,
      isFalse,
    );
    expect(
      const AuthConfig(
        supabaseUrl: 'bukan-url',
        publishableKey: key,
        googleWebClientId: '',
      ).canUseSupabase,
      isFalse,
    );
  });

  test('google needs a configured project plus a public web client id', () {
    expect(
      const AuthConfig(
        supabaseUrl: 'https://x.supabase.co',
        publishableKey: key,
        googleWebClientId: 'client.apps.googleusercontent.com',
      ).canUseGoogle,
      isTrue,
    );
    expect(
      const AuthConfig(
        supabaseUrl: 'https://x.supabase.co',
        publishableKey: key,
        googleWebClientId: '',
      ).canUseGoogle,
      isFalse,
    );
  });

  test('callback predicate accepts only laurum auth links with credentials', () {
    expect(isAuthCallbackUri(Uri.parse('laurum://auth-callback?code=abc')), isTrue);
    expect(isAuthCallbackUri(Uri.parse('laurum://auth-callback#access_token=abc')), isTrue);
    expect(isAuthCallbackUri(Uri.parse('laurum://auth-callback?error=access_denied')), isTrue);
    expect(isAuthCallbackUri(Uri.parse('laurum://auth-callback')), isFalse);
    expect(isAuthCallbackUri(Uri.parse('laurum://lain?code=abc')), isFalse);
    expect(isAuthCallbackUri(Uri.parse('https://auth-callback?code=abc')), isFalse);
  });

  test('android manifest registers the same deep link', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('android:scheme="laurum"'));
    expect(manifest, contains('android:host="auth-callback"'));
    expect(manifest, contains('android.intent.action.VIEW'));
    expect(Uri.parse(authCallbackUri).scheme, 'laurum');
    expect(Uri.parse(authCallbackUri).host, 'auth-callback');
  });
}
