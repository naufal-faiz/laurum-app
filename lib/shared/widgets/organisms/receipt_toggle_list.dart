import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/atoms/app_card.dart';
import 'package:laurum/shared/widgets/molecules/locked_row.dart';
import 'package:laurum/shared/widgets/molecules/toggle_row.dart';

class ReceiptToggleList extends StatelessWidget {
  const ReceiptToggleList({
    required this.showAddress,
    required this.showCustomer,
    required this.showSavings,
    required this.showNote,
    super.key,
    this.onAddressChanged,
    this.onCustomerChanged,
    this.onSavingsChanged,
    this.onNoteChanged,
  });

  final bool showAddress, showCustomer, showSavings, showNote;
  final ValueChanged<bool>? onAddressChanged, onCustomerChanged, onSavingsChanged, onNoteChanged;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToggleRow(
          label: 'Alamat & nomor telepon',
          icon: AppIcons.location,
          value: showAddress,
          onChanged: onAddressChanged,
        ),
        const LockedRow(
          label: 'Nomor nota & tanggal',
          icon: AppIcons.calendar,
          lockLabel: 'Selalu tampil',
        ),
        ToggleRow(
          label: 'Nama pelanggan',
          icon: AppIcons.person,
          value: showCustomer,
          onChanged: onCustomerChanged,
        ),
        const LockedRow(
          label: 'Rincian item & diskon',
          icon: AppIcons.receipt,
          lockLabel: 'Selalu tampil',
        ),
        ToggleRow(
          label: 'Tabungan & sisa saldo',
          icon: AppIcons.wallet,
          value: showSavings,
          onChanged: onSavingsChanged,
        ),
        ToggleRow(
          label: 'Catatan khusus nota',
          icon: AppIcons.info,
          value: showNote,
          onChanged: onNoteChanged,
        ),
      ],
    ),
  );
}
