import 'package:go_router/go_router.dart';
import 'package:laurum/features/business/pages/business_info_page.dart';
import 'package:laurum/features/printer/pages/printer_page.dart';
import 'package:laurum/features/services/pages/service_directory_page.dart';
import 'package:laurum/features/services/pages/service_edit_page.dart';

final lainnyaRoutes = <RouteBase>[
  GoRoute(path: '/lainnya/printer', builder: (context, state) => const PrinterPage()),
  GoRoute(path: '/lainnya/layanan/baru', builder: (context, state) => const ServiceEditPage()),
  GoRoute(
    path: '/lainnya/layanan/:id',
    builder: (context, state) => ServiceEditPage(serviceId: state.pathParameters['id']!),
  ),
  GoRoute(path: '/lainnya/layanan', builder: (context, state) => const ServiceDirectoryPage()),
  GoRoute(path: '/lainnya/info-usaha', builder: (context, state) => const BusinessInfoPage()),
];
