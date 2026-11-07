import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:laurum/core/sync/canonical_json.dart';

String syncHash(Object? value) => sha256.convert(utf8.encode(canonicalJson(value))).toString();
