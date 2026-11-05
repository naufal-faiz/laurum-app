import 'package:flutter/foundation.dart';

const configuredStore = String.fromEnvironment('LAURUM_STORE', defaultValue: 'drift');
const demoSeedEnabled = !kReleaseMode || bool.fromEnvironment('DEMO_SEED');

bool usesDrift(String value) => switch (value) {
  'drift' => true,
  'memory' => false,
  _ => throw ArgumentError('LAURUM_STORE must be drift or memory'),
};
