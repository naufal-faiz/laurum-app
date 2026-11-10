import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/organisms/welcome_banner.dart';

/// Welcome card of frame `LAURUM · Beranda` with the business name.
class BerandaWelcomeSection extends StatelessWidget {
  const BerandaWelcomeSection({
    required this.businessName,
    required this.onManageQueue,
    super.key,
  });

  final String businessName;
  final VoidCallback onManageQueue;

  @override
  Widget build(BuildContext context) => WelcomeBanner(
    greeting: 'Selamat datang kembali,',
    businessName: businessName,
    subtitle: 'Siap untuk kembali bekerja',
    actionLabel: 'Kelola antrean',
    onAction: onManageQueue,
  );
}
