import 'package:flutter/material.dart';
import 'package:laurum/features/proposals/pages/proposal_weight_sheet.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

Future<void> showProposalWeightSheet(
  BuildContext context, {
  required String id,
  required String value,
  required ValueChanged<String> onChanged,
}) => AppBottomSheet.show<void>(
  context: context,
  title: 'Isi berat',
  subtitle: 'Berat dipakai untuk menghitung total layanan kiloan.',
  child: ProposalWeightSheet(id: id, value: value, onChanged: onChanged),
);
