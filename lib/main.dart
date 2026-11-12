import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:laurum/app.dart';
import 'package:laurum/core/persistence/drift_repository_overrides.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/persistence/supabase_bootstrap.dart';
import 'package:laurum/core/persistence/sync_bindings.dart';
import 'package:laurum/core/services/auth_config.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/core/services/store_configuration.dart';
import 'package:laurum/core/sync/background_sync.dart';
import 'package:laurum/core/sync/supabase_sync_cycle.dart';
import 'package:laurum/features/auth/data/supabase_auth_factory.dart';
import 'package:laurum/features/printer/data/ble_printer_transport.dart';
import 'package:laurum/features/printer/data/esc_pos_print_service.dart';
import 'package:laurum/features/shell/pages/app_router.dart';
import 'package:laurum/main_dummy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  final drift = usesDrift(configuredStore);
  final realAuth = drift && await initializeSupabase(authConfigFromEnvironment);
  if (realAuth && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await scheduleBackgroundSync();
    } catch (_) {
      /* Scheduling must never block the first frame. */
    }
  }
  final container = ProviderContainer(
    overrides: [
      ...(drift
          ? driftRepositoryOverrides(
              auth: realAuth
                  ? supabaseAuthService(
                      authConfigFromEnvironment,
                      recovery: recoveryLinkAtStartup,
                    )
                  : null,
            )
          : dummyRepositoryOverrides),
      realConnectionMonitor(),
      if (drift)
        printServiceProvider.overrideWithValue(
          EscPosPrintService(BlePrinterTransport()),
        ),
      if (realAuth) syncCycleFactoryProvider.overrideWithValue(supabaseSyncCycleFromSession()),
    ],
  );
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: LaurumApp(router: createAppRouter(container: container)),
    ),
  );
}
