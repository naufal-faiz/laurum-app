import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/services/dummy_history.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/sync/data/sync_fixtures.dart';
import 'package:laurum/features/sync/state/sync_view.dart';
import 'package:laurum/features/sync/widgets/sync_status_section.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class SyncPage extends ConsumerWidget {
  const SyncPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(syncViewProvider);
    final action = ref.watch(syncActionsProvider);
    return SubScaffold(
      title: 'Sinkronisasi',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: SyncStatusSection(
          data: data,
          busy: action.isLoading,
          failed: action.hasError,
          conflictExample: ref.watch(dummyHistoryProvider) ? syncConflictExample : '',
          onSync: () => ref.read(syncActionsProvider.notifier).syncNow(),
        ),
      ),
    );
  }
}
