import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/supabase_bootstrap.dart';
import 'package:laurum/core/persistence/sync_bindings.dart';
import 'package:laurum/core/services/auth_config.dart';
import 'package:laurum/core/services/store_configuration.dart';
import 'package:laurum/features/auth/data/supabase_auth_factory.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/main_dummy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  final drift = usesDrift(configuredStore);
  final realAuth = drift && await initializeSupabase(authConfigFromEnvironment);
  final container = ProviderContainer(
    overrides: [
      ...(drift
          ? driftRepositoryOverrides(
              auth: realAuth ? supabaseAuthService(authConfigFromEnvironment) : null,
            )
          : dummyRepositoryOverrides),
      realConnectionMonitor(),
    ],
  );
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: LaurumApp(router: createAppRouter(container: container)),
    ),
  );
}
