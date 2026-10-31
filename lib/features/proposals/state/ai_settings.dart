import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AiPreferences = ({bool readMessages, bool ignoreGroups, bool detectCancellation});

class AiSettings extends Notifier<AiPreferences> {
  @override
  AiPreferences build() => (readMessages: true, ignoreGroups: true, detectCancellation: true);
  void readMessages({required bool enabled}) => state = (
    readMessages: enabled,
    ignoreGroups: state.ignoreGroups,
    detectCancellation: state.detectCancellation,
  );
  void ignoreGroups({required bool enabled}) => state = (
    readMessages: state.readMessages,
    ignoreGroups: enabled,
    detectCancellation: state.detectCancellation,
  );
  void detectCancellation({required bool enabled}) => state = (
    readMessages: state.readMessages,
    ignoreGroups: state.ignoreGroups,
    detectCancellation: enabled,
  );
}

final aiSettingsProvider = NotifierProvider<AiSettings, AiPreferences>(AiSettings.new);
