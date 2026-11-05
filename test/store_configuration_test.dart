import 'package:flutter_test/flutter_test.dart';
import 'package:laurum/core/services/store_configuration.dart';

void main() {
  test('Drift is default, explicit memory supported, invalid store rejected', () {
    expect(configuredStore, 'drift');
    expect(usesDrift('drift'), isTrue);
    expect(usesDrift('memory'), isFalse);
    expect(() => usesDrift('unknown'), throwsArgumentError);
  });
}
