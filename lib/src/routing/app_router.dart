import 'package:go_router/go_router.dart';

import '../core/models/models.dart';
import '../features/events/views/events_page.dart';
import '../features/leads/lead_detail/views/lead_detail_page.dart';
import '../features/leads/my_leads/views/leads_page.dart';
import 'routing.dart';

class AppRouter {
  const AppRouter._();

  static final _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: AppRoute.events.name,
        builder: (context, state) => const EventsPage(),
        routes: [
          GoRoute(
            path: "leads",
            name: AppRoute.leads.name,
            pageBuilder: (_, state) {
              final event = state.extra as Event;
              return CustomSlideTransition(
                key: state.pageKey,
                child: LeadsPage(event: event),
              );
            },
            routes: [
              GoRoute(
                path: "detail",
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
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
