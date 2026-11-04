import 'package:uuid/uuid.dart';

class IdGenerator {
  const IdGenerator();
  static const _uuid = Uuid();

  String newId() => _uuid.v4();

  // A fixed namespace also accepts the legacy fixture parents until B1f seeds UUIDs.
  // Nesting namespaces avoids ambiguous parent/label concatenation.
  String derived(String parentId, String label) =>
      _uuid.v5(_uuid.v5(Namespace.url.value, parentId), label);
}
