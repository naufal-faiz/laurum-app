import 'package:laurum/core/services/auth_config.dart';
import 'package:laurum/core/services/auth_service.dart';
import 'package:laurum/features/auth/data/google_token_source.dart';
import 'package:laurum/features/auth/data/supabase_auth_gateway.dart';
import 'package:laurum/features/auth/data/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Real service for builds that passed [initializeSupabase].
AuthService supabaseAuthService(AuthConfig config, {bool recovery = false}) {
  final service = SupabaseAuthService(
    SupabaseAuthGateway(Supabase.instance.client),
    GoogleSignInTokenSource(config.googleWebClientId),
  );
  service.watchRecovery(active: recovery);
  return service;
}
