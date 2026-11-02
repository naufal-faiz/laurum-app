import 'package:flutter/material.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/features/auth/state/password_reset_view.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';
import 'package:laurum/shared/widgets/atoms/app_text_field.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';
import 'package:laurum/shared/widgets/molecules/labeled_field.dart';

class PasswordResetSection extends StatelessWidget {
  const PasswordResetSection({required this.data, required this.onEmail, super.key});
  final PasswordResetView data;
  final ValueChanged<String> onEmail;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.cardGap,
    children: [
      const AppText('Masukkan email untuk menerima tautan reset password.'),
      LabeledField(
        label: 'Email',
        errorText: data.emailError,
        child: AppTextField(
          label: 'Email',
          value: data.email,
          selectAllOnFocus: true,
          enabled: !data.busy,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmail,
        ),
      ),
      if (data.sent) const BannerMessage(message: 'Jika email terdaftar, tautan dikirim'),
      if (data.error != null)
        BannerMessage(message: data.error!, variant: BannerMessageVariant.error),
    ],
  );
}
