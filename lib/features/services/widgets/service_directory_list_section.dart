import 'package:flutter/material.dart';
import 'package:laurum/core/domain/service_item.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_gap.dart';
import 'package:laurum/shared/widgets/organisms/service_row.dart';

class ServiceDirectoryListSection extends StatelessWidget {
  const ServiceDirectoryListSection({
    required this.services,
    required this.onTap,
    required this.onToggle,
    super.key,
  });

  final List<ServiceItem> services;
  final ValueChanged<ServiceItem> onTap;
  final void Function(ServiceItem service, {required bool active}) onToggle;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
    itemCount: services.length,
    separatorBuilder: (_, _) => const AppGap(),
    itemBuilder: (context, index) {
      final service = services[index];
      return ServiceRow(
        name: service.name,
        kind: service.kind,
        price: service.price,
        durationDays: service.durationDays,
        isActive: service.isActive,
        onTap: () => onTap(service),
        onActiveChanged: (active) => onToggle(service, active: active),
      );
    },
  );
}
