import 'package:flutter/material.dart';
import 'package:laurum/core/domain/domain_enums.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/formatters/formatters.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/shared/widgets/molecules/menu_row.dart';
import 'package:laurum/shared/widgets/organisms/app_bottom_sheet.dart';

Future<void> showProposalServicePicker(
  BuildContext context, {
  required List<ServiceItem> services,
  required String selectedId,
  required ValueChanged<String> onService,
}) => AppBottomSheet.show<void>(
  context: context,
  title: 'Pilih layanan',
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final item in services)
        MenuRow(
          label: item.name,
          subtitle:
              '${Formatters.rupiah(item.price)} / ${item.kind == ServiceKind.kiloan ? 'kg' : 'pcs'}',
          icon: item.id == selectedId ? AppIcons.check : AppIcons.service,
          onTap: () {
            onService(item.id);
            Navigator.of(context).pop();
          },
        ),
    ],
  ),
);
