import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/services/sync_service.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/beranda/widgets/beranda_header_section.dart';
import 'package:laurum/features/customers/state/customer_directory_data.dart';
import 'package:laurum/features/customers/widgets/customer_header_section.dart';
import 'package:laurum/features/orders/state/antrean_data.dart';
import 'package:laurum/features/orders/state/antrean_search.dart';
import 'package:laurum/features/orders/widgets/antrean_header_section.dart';
import 'package:laurum/features/settings/widgets/settings_header_section.dart';
import 'package:laurum/features/shell/state/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/sync_indicator.dart';
import 'package:laurum/shared/widgets/templates/root_scaffold.dart';

class RootShellPage extends ConsumerWidget {
  const RootShellPage({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(businessProfileProvider);
    final sync = ref.watch(shellSyncProvider);
    final index = navigationShell.currentIndex;
    final settings = index == 3 && GoRouterState.of(context).uri.path == '/lainnya';
    final queue = index == 1 ? ref.watch(antreanDataProvider).value : null;
    final search = index == 1 ? ref.watch(antreanSearchProvider) : (open: false, query: '');
    final customers = index == 2 ? ref.watch(customerDirectoryProvider).value : null;
    final syncState = sync.hasError
        ? SyncState.gagal
        : SyncState.values.byName(sync.value?.name ?? 'menyimpan');
    return RootScaffold(
      title: profile.value?.name ?? 'Laurum',
      accountLabel: 'Usaha dan akun',
      activeIndex: navigationShell.currentIndex,
      showAppBar: index > 1,
      pageHeader: settings
          ? SettingsHeaderSection(
              name: profile.value?.name ?? 'Laurum',
              syncState: syncState,
              onAccount: () => navigationShell.goBranch(3),
            )
          : index == 1
          ? AntreanHeaderSection(
              searchOpen: search.open,
              total: queue?.orders.length ?? 0,
              reviewCount: queue?.proposals.length ?? 0,
              syncState: syncState,
              onSearch: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read(antreanSearchProvider.notifier).toggle();
              },
            )
          : index == 2
          ? CustomerHeaderSection(
              count: customers?.length,
              syncState: syncState,
              onAccount: () => navigationShell.goBranch(3),
            )
          : null,
      header: index == 0
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: BerandaHeaderSection(),
            )
          : null,
      syncState: syncState,
      onAccount: () => navigationShell.goBranch(3),
      onTabSelected: navigationShell.goBranch,
      onCreate: () => context.push('/transaksi/baru'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (sync.value == SyncServiceStatus.offline)
              const BannerMessage(
                message: 'Mode offline. Data tersimpan di HP dan disinkronkan otomatis.',
              ),
            if (sync.hasError || sync.value == SyncServiceStatus.gagal)
              const BannerMessage(
                message: 'Sinkronisasi gagal. Data di HP tetap tersimpan.',
                variant: BannerMessageVariant.error,
              ),
            if (navigationShell.currentIndex == 1 && !ref.watch(whatsappConnectionProvider)) ...[
              const BannerMessage(
                message: 'WhatsApp terputus. AI berhenti membaca pesan.',
                variant: BannerMessageVariant.warning,
              ),
              AppButton(
                'Hubungkan',
                variant: AppButtonVariant.actionOutline,
                onPressed: () => context.push('/lainnya/ai/hubungkan'),
              ),
            ],
            Expanded(child: navigationShell),
          ],
        ),
      ),
    );
  }
}
