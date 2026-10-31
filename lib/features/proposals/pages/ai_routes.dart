import 'package:go_router/go_router.dart';
import 'package:laurum/features/proposals/pages/ai_settings_page.dart';
import 'package:laurum/features/proposals/pages/whatsapp_link_page.dart';

final aiRoutes = <RouteBase>[
  GoRoute(path: '/lainnya/ai/hubungkan', builder: (context, state) => const WhatsappLinkPage()),
  GoRoute(path: '/lainnya/ai', builder: (context, state) => const AiSettingsPage()),
];
