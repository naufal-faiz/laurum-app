/// Sync trigger timing from PRD B §7: 2-second debounce after a local write,
/// exponential retry capped at 15 minutes, and a ~15-minute periodic trigger.
const syncDebounce = Duration(seconds: 2);
const syncRetryBase = Duration(seconds: 2);
const syncRetryMax = Duration(minutes: 15);
const syncPeriodic = Duration(minutes: 15);

Duration syncRetryDelay(int attempt) {
  if (attempt < 1) return syncRetryBase;
  final shift = attempt > 11 ? 10 : attempt - 1;
  final millis = syncRetryBase.inMilliseconds * (1 << shift);
  return millis >= syncRetryMax.inMilliseconds ? syncRetryMax : Duration(milliseconds: millis);
}
