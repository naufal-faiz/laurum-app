String normalizeProposalWeight(String value) {
  final parts = value.replaceAll('.', ',').replaceAll(RegExp(r'[^0-9,]'), '').split(',');
  final text = '${parts.first}${parts.length > 1 ? ',${parts[1]}' : ''}'.replaceFirst(
    RegExp(r'^0+(?=\d)'),
    '',
  );
  return text == '0' ? '' : text;
}

class ProposalDraft {
  const ProposalDraft({
    required this.name,
    required this.phone,
    required this.address,
    required this.serviceId,
    this.weight = '',
  });
  final String name, phone, address, serviceId, weight;
  bool get valid => name.trim().isNotEmpty && serviceId.isNotEmpty;
  bool get phoneValid =>
      phone.trim().isEmpty ||
      RegExp(r'^08\d{8,11}$')
          .hasMatch(phone.replaceAll(RegExp(r'[\s()-]'), '').replaceFirst(RegExp(r'^\+?62'), '0'));
  int get weightMilli => ((double.tryParse(weight.replaceAll(',', '.')) ?? 0) * 1000).round();
  String? get weightError =>
      weight.isNotEmpty && weightMilli < 500 ? 'Berat minimal 0,5 kg.' : null;
  ProposalDraft copyWith({
    String? name,
    String? phone,
    String? address,
    String? serviceId,
    String? weight,
  }) => ProposalDraft(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    serviceId: serviceId ?? this.serviceId,
    weight: weight ?? this.weight,
  );
}
