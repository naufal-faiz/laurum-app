import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/molecules/banner_message.dart';

class BusinessNoteSection extends StatelessWidget {
  const BusinessNoteSection({super.key});

  @override
  Widget build(BuildContext context) => const BannerMessage(
    message: 'Perubahan tampil di struk dan nota setelah disimpan.',
  );
}
