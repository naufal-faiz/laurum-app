import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    return AuthScaffold(
      child: SignInSection(
        busy: session.busy,
        restoring: session.signedIn,
        error: session.error,
        onGoogle: () => ref.read(authSessionProvider.notifier).signIn(),
      ),
    );
  }
}
