import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laurum/core/services/print_service.dart';
import 'package:laurum/core/services/repository_providers.dart';
import 'package:laurum/core/services/service_providers.dart';
import 'package:laurum/main_dummy.dart';

class CompletionPrinter extends FakePrintService {
  CompletionPrinter({super.printSucceeds});
  Completer<bool>? gate;
  bool throwsOnPrint = false;
  int calls = 0;

  @override
  Future<bool> printReceipt(ReceiptData data) async {
    calls++;
    if (throwsOnPrint) throw StateError('Printer disconnected');
    if (gate != null && !await gate!.future) return false;
    return super.printReceipt(data);
  }
}

Future<ProviderContainer> completionScope(
  CompletionPrinter printer, {
  bool tracking = false,
}) async {
  await printer.connect(printer.devices.first);
  final scope = ProviderContainer(
    overrides: [
      ...dummyRepositoryOverrides,
      printServiceProvider.overrideWithValue(printer),
    ],
  );
  final business = scope.read(businessRepositoryProvider);
  await business.saveProfile((await business.getProfile()).withOrderStatus(enabled: tracking));
  return scope;
}
