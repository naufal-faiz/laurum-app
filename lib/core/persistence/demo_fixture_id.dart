import 'package:laurum/core/domain/id_generator.dart';

// UUID v5 gives the same demo row and relationship on an idempotent seed retry.
String demoFixtureId(String ownerId, String fixtureId) =>
    const IdGenerator().derived(ownerId, 'demo:$fixtureId');
