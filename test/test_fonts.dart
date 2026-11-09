import 'package:flutter/services.dart';

/// Memuat font aplikasi untuk tes golden: Inter (400/600/700), IBM Plex Mono,
/// dan Ionicons.
Future<void> loadTestFonts() async {
  const families = <String, List<String>>{
    'Inter': [
      'assets/fonts/Inter-Regular.otf',
      'assets/fonts/Inter-SemiBold.otf',
      'assets/fonts/Inter-Bold.otf',
    ],
    'IBM Plex Mono': ['assets/fonts/IBMPlexMono-Regular.ttf'],
    'packages/ionicons/Ionicons': ['packages/ionicons/assets/fonts/Ionicons.ttf'],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }
}
