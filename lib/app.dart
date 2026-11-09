import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/persistence/sync_bindings.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class LaurumApp extends ConsumerWidget {
  const LaurumApp({required this.router, super.key});
  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncBindingsProvider);
    final storage = ref.watch(storageGateEnabledProvider) ? ref.watch(accountStoreProvider) : null;
    return MaterialApp.router(
      title: 'Laurum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        if (storage == null || (!storage.isLoading && !storage.hasError)) return child!;
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: EmptyState(
                title: storage.hasError ? 'Penyimpanan belum dapat dibuka' : 'Membuka data lokal',
                icon: storage.hasError ? AppIcons.alert : AppIcons.queue,
                description: storage.hasError
                    ? 'Data Anda tetap tersimpan. Coba buka kembali penyimpanan.'
                    : 'Tunggu sebentar, data usaha sedang disiapkan.',
                actionLabel: storage.hasError ? 'Coba lagi' : null,
                onAction: storage.hasError ? () => ref.invalidate(accountStoreProvider) : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
