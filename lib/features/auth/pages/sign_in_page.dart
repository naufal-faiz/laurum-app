import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/sign_in_form_card_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_hero_section.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final form = ref.watch(authFormProvider(AuthFormKind.signIn));
    final controller = ref.read(authFormProvider(AuthFormKind.signIn).notifier);
    final busy = form.busy || session.busy;
    final error = form.error ?? session.error;

    return Scaffold(
      body: Stack(
        children: [
          const SignInHeroSection(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 280),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: SignInFormCardSection(
                    form: form,
                    busy: busy,
                    onEmail: controller.email,
                    onPassword: (value) => controller.secret(AuthSecret.password, value),
                    onTogglePassword: controller.toggleVisible,
                    onForgotPassword: () => context.go('/lupa-password'),
                    onSignIn: controller.submit,
                    onGoogle: () {
                      controller.clearError();
                      ref.read(authSessionProvider.notifier).signIn();
                    },
                    onSignUp: () => context.go('/daftar'),
                    sessionBusy: session.busy,
                    sessionSignedIn: session.signedIn,
                  ),
                ),
                const SizedBox(height: 24),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: BannerMessage(
                      message: error,
                      variant: BannerMessageVariant.error,
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const AppSvg('assets/icons/cursor-back.svg', size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
