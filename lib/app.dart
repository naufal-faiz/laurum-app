import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/persistence/storage_providers.dart';
import 'package:laurum/core/persistence/sync_bindings.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_theme.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/reports/state/report_view.dart';
import 'package:laurum/shared/widgets/atoms/app_loader.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';

class LaurumApp extends ConsumerWidget {
  const LaurumApp({required this.router, super.key});
  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncBindingsProvider);
    final storage = ref.watch(storageGateEnabledProvider) ? ref.watch(accountStoreProvider) : null;
    var readingInitialData = false;
    if (storage != null && !storage.isLoading && !storage.hasError && storage.value != null) {
      readingInitialData = [
        ref.watch(antreanDataProvider),
        ref.watch(customerDirectoryProvider),
        ref.watch(reportViewProvider),
      ].any((value) => value.isLoading && !value.hasValue);
    }
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
        if (storage == null || (!storage.isLoading && !storage.hasError && !readingInitialData)) {
          return child!;
        }
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: storage.hasError
                  ? EmptyState(
                      title: 'Penyimpanan belum dapat dibuka',
                      icon: AppIcons.alert,
                      description: 'Data Anda tetap tersimpan. Coba buka kembali penyimpanan.',
                      actionLabel: 'Coba lagi',
                      onAction: () => ref.invalidate(accountStoreProvider),
                    )
                  : const Padding(
                      key: ValueKey('local-storage-loading'),
                      padding: EdgeInsets.all(AppSpacing.screenPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: AppSpacing.cardGap,
                        children: [
                          AppLoader(),
                          AppText(
                            'Membuka data lokal',
                            variant: AppTextVariant.section,
                            textAlign: TextAlign.center,
                          ),
                          AppText(
                            'Tunggu sebentar, data usaha sedang disiapkan.',
                            color: AppColors.ink2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
