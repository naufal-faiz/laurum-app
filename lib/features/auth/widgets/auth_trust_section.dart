import 'package:flutter/material.dart';
import 'package:laurum/shared/widgets/molecules/trust_note.dart';

/// Static "data aman & terenkripsi" line of the auth frames.
class AuthTrustSection extends StatelessWidget {
  const AuthTrustSection({this.text = 'Data usaha kamu aman & terenkripsi', super.key});

  final String text;

  @override
  Widget build(BuildContext context) => TrustNote(text: text);
}
