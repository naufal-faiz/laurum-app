import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/auth_trust_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_feature_bar_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_form_card_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_hero_section.dart';
import 'package:laurum/shared/widgets/templates/auth_scaffold.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final form = ref.watch(authFormProvider(AuthFormKind.signIn));
    final controller = ref.read(authFormProvider(AuthFormKind.signIn).notifier);
    final busy = form.busy || session.busy;
    final error = form.error ?? session.error;

    return AuthScaffold(
      hero: const SignInHeroSection(),
      contentTop: 320,
      background: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
            child: SignInFormCardSection(
              email: form.email,
              visible: form.visible,
              busy: busy,
              restoring: session.signedIn,
              errors: form.errors,
              error: error,
              onEmail: controller.email,
              onPassword: (value) => controller.secret(AuthSecret.password, value),
              onToggle: controller.toggleVisible,
              onForgot: () => context.go('/lupa-password'),
              onSubmit: controller.submit,
              onGoogle: () {
                controller.clearError();
                ref.read(authSessionProvider.notifier).signIn();
              },
              onSignUp: () => context.go('/daftar'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxlarge),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
            child: SignInFeatureBarSection(),
          ),
          const SizedBox(height: AppSpacing.largeX),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
            child: AuthTrustSection(),
          ),
        ],
      ),
    );
  }
}
