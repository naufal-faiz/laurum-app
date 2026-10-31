import 'dart:async';

import 'package:laurum/core/domain/business_profile.dart';
import 'package:laurum/features/business/data/in_memory_business_repository.dart';

class BusinessSaveControl {
  bool fail = false;
  Completer<void>? gate;
  int saves = 0;
}

class ControlledBusiness extends InMemoryBusinessRepository {
  ControlledBusiness(this._control);
  final BusinessSaveControl _control;

  @override
  Future<void> saveProfile(BusinessProfile profile) async {
    _control.saves++;
    if (_control.gate != null) await _control.gate!.future;
    if (_control.fail) throw Exception('Disk unavailable');
    await super.saveProfile(profile);
  }
}
