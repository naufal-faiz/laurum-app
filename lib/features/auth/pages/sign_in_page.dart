import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_shadows.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/features/auth/state/auth_form.dart';
import 'package:laurum/features/auth/state/auth_form_view.dart';
import 'package:laurum/features/auth/state/auth_session.dart';
import 'package:laurum/features/auth/widgets/auth_identity_section.dart';
import 'package:laurum/features/auth/widgets/auth_password_inline_section.dart';
import 'package:laurum/features/auth/widgets/sign_in_section.dart';
import 'package:laurum/shared/widgets/atoms/app_button.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_svg.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
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
          const _SignInHeroSection(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 280),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: _SignInFormCard(
                    form: form,
                    busy: busy,
                    error: error,
                    controller: controller,
                    session: session,
                    ref: ref,
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

class _SignInHeroSection extends StatelessWidget {
  const _SignInHeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.authHeroGradientStart,
            AppColors.authHeroGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -60,
            bottom: 40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const AppIcon(
                            AppIcons.droplet,
                            color: AppColors.authHeroGradientEnd,
                            size: 22,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              'LAURUM',
                              style: AppTextStyles.heroLogo.copyWith(color: AppColors.surface),
                            ),
                            Text(
                              'LAUNDRY MANAGEMENT',
                              style: AppTextStyles.heroLogoSub.copyWith(
                                color: AppColors.authHeroTagline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Masuk',
                      style: AppTextStyles.heroTitle.copyWith(color: AppColors.surface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kasir laundry untuk usaha rumahan',
                      style: AppTextStyles.heroTagline.copyWith(
                        color: AppColors.authHeroTagline,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          Positioned(
            right: 24,
            bottom: 20,
            child: SizedBox(
              width: 118,
              height: 118,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue.withValues(alpha: 0.2),
                    ),
                  ),
                  AppIcon(
                    AppIcons.service,
                    size: 48,
                    color: AppColors.surface.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInFormCard extends StatelessWidget {
  const _SignInFormCard({
    required this.form,
    required this.busy,
    required this.error,
    required this.controller,
    required this.session,
    required this.ref,
  });

  final AuthFormView form;
  final bool busy;
  final String? error;
  final AuthForm controller;
  final AuthState session;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.authCard,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          AuthIdentitySection(
            email: form.email,
            busy: busy,
            errors: form.errors,
            onEmail: controller.email,
          ),
          _PasswordLabelRow(
            busy: busy,
            onForgot: () => context.go('/lupa-password'),
          ),
          AuthPasswordInlineSection(
            visible: form.visible,
            busy: busy,
            error: form.errors['password'],
            onPassword: (value) => controller.secret(AuthSecret.password, value),
            onToggle: controller.toggleVisible,
          ),
          const SizedBox(height: 4),
          AppButton(
            'Masuk',
            onPressed: busy ? null : controller.submit,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: AppText('atau', textAlign: TextAlign.center),
          ),
          SignInSection(
            busy: busy,
            restoring: session.signedIn,
            onGoogle: () {
              controller.clearError();
              ref.read(authSessionProvider.notifier).signIn();
            },
          ),
          Center(
            child: Wrap(
              spacing: 4,
              children: [
                Text(
                  'Belum punya akun?',
                  style: AppTextStyles.body.copyWith(color: AppColors.ink3),
                ),
                GestureDetector(
                  onTap: busy ? null : () => context.go('/daftar'),
                  child: Text(
                    'Daftar',
                    style: AppTextStyles.body.copyWith(color: AppColors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordLabelRow extends StatelessWidget {
  const _PasswordLabelRow({
    required this.busy,
    required this.onForgot,
  });

  final bool busy;
  final VoidCallback onForgot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Password',
            style: AppTextStyles.label.copyWith(color: AppColors.ink3),
          ),
          GestureDetector(
            onTap: busy ? null : onForgot,
            child: Text(
              'Lupa password?',
              style: AppTextStyles.body.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
