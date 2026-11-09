import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/auth_trust_section.dart';
import 'package:laurum/features/auth/widgets/sign_up_form_card_section.dart';
import 'package:laurum/features/auth/widgets/sign_up_hero_section.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final form = ref.watch(authFormProvider(AuthFormKind.signUp));
    final controller = ref.read(authFormProvider(AuthFormKind.signUp).notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          SignUpHeroSection(onBack: () => context.go('/masuk')),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 200, bottom: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SignUpFormCardSection(
                    name: form.name,
                    email: form.email,
                    visible: form.visible,
                    busy: form.busy || session.busy,
                    restoring: session.signedIn,
                    errors: form.errors,
                    error: form.error ?? session.error,
                    onName: controller.name,
                    onEmail: controller.email,
                    onPassword: (value) => controller.secret(AuthSecret.password, value),
                    onConfirmation: (value) => controller.secret(AuthSecret.confirmation, value),
                    onToggle: controller.toggleVisible,
                    onSubmit: () async {
                      if (await controller.submit() && context.mounted) {
                        context.go('/cek-email');
                      }
                    },
                    onGoogle: () {
                      controller.clearError();
                      ref.read(authSessionProvider.notifier).signIn();
                    },
                    onSignIn: () => context.go('/masuk'),
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: AuthTrustSection(text: 'Data kamu aman & terenkripsi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
