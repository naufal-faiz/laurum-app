import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/proposals/state/whatsapp_link.dart';
import 'package:laurum/features/proposals/widgets/whatsapp_link_section.dart';
import 'package:laurum/shared/widgets/templates/sub_scaffold.dart';

class WhatsappLinkPage extends ConsumerWidget {
  const WhatsappLinkPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(whatsappLinkProvider);
    final actions = ref.read(whatsappLinkProvider.notifier);
    return SubScaffold(
      title: 'Hubungkan WhatsApp',
      backLabel: 'Kembali',
      onBack: () => context.canPop() ? context.pop() : context.go('/lainnya/ai'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: WhatsappLinkSection(
          status: status,
          onCheck: actions.check,
          onRefresh: actions.refresh,
          onDone: () => context.go('/lainnya/ai'),
        ),
      ),
    );
  }
}
