import 'package:go_router/go_router.dart';

import '../../core/models/models.dart';
import '../../core/utils/enums/enums.dart';
import '../events/views/events_page.dart';
import '../leads/lead_detail/views/lead_detail_page.dart';
import '../leads/my_leads/views/leads_page.dart';
import 'custom_slide_transition.dart';

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
        pageBuilder: (_, state) {
          final event = state.extra as Event;
          return CustomSlideTransition(
            key: state.pageKey,
            child: LeadsPage(event: event),
          );
        },
      ),
      GoRoute(
        path: "/leads/detail",
        name: AppRoute.leadDetail.name,
        pageBuilder: (_, state) {
          final lead = state.extra as Lead;
          return CustomSlideTransition(
            key: state.pageKey,
            child: LeadDetailPage(lead: lead),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
