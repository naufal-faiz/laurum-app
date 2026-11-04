import 'dart:async';

typedef RepositoryFactory<T> = FutureOr<T> Function();
