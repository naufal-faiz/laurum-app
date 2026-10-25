import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/services/pages/service_copy.dart';
import 'package:laurum/features/services/pages/service_directory_content_page.dart';
import 'package:laurum/features/services/pages/service_directory_providers.dart';
import 'package:laurum/features/shell/pages/shell_state.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_skeleton.dart';
import 'package:laurum/shared/widgets/molecules/empty_state.dart';
import 'package:laurum/shared/widgets/molecules/footer_bar.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class ServiceDirectoryPage extends ConsumerWidget {
  const ServiceDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directory = ref.watch(serviceDirectoryProvider);
    final query = ref.watch(serviceDirectorySearchProvider);
    return SubScaffold(
      title: 'Daftar layanan',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      body: Column(
        children: [
          Expanded(
            child: directory.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [for (var i = 0; i < 4; i++) const AppSkeleton()],
              ),
              error: (_, _) => Center(
                child: EmptyState(
                  title: 'Gagal memuat layanan',
                  icon: AppIcons.alert,
                  actionLabel: 'Coba lagi',
                  onAction: () => ref.invalidate(serviceDirectoryProvider),
                ),
              ),
              data: (services) => ServiceDirectoryContentPage(
                services: services,
                query: query,
                onQuery: ref.read(serviceDirectorySearchProvider.notifier).set,
                onTap: (service) => context.push('/lainnya/layanan/${service.id}'),
                onToggle: (service, {required active}) => ref
                    .read(serviceRepositoryProvider)
                    .saveService(
                      copyService(
                        service,
                        isActive: active,
                        updatedAt: ref.read(businessClockProvider)(),
                      ),
                    ),
              ),
            ),
          ),
          FooterBar(
            child: AppButton(
              'Tambah layanan',
              onPressed: () => context.push('/lainnya/layanan/baru'),
            ),
          ),
        ],
      ),
    );
  }
}
