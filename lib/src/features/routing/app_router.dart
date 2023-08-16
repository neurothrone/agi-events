import 'package:go_router/go_router.dart';

import '../../core/models/models.dart';
import '../../core/utils/enums/app_route.dart';
import '../events/views/events_page.dart';
import '../leads/lead_detail/views/lead_detail_page.dart';
import '../leads/my_leads/views/leads_page.dart';

class AppRouter {
  const AppRouter._();

  static final _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: AppRoute.events.name,
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: "/leads",
        name: AppRoute.leads.name,
        builder: (context, state) {
          final event = state.extra as Event;
          return LeadsPage(event: event);
        },
      ),
      GoRoute(
        path: "/leads/detail",
        name: AppRoute.leadDetail.name,
        builder: (context, state) {
          final lead = state.extra as Lead;
          return LeadDetailPage(lead: lead);
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
