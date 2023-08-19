import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/widgets/widgets.dart';
import '../data/events_controller.dart';
import 'your_events_placeholder.dart';
import 'events_grid.dart';

class YourEventsGrid extends ConsumerWidget {
  const YourEventsGrid({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  void _navigateToLeadsPage({
    required Event event,
    required BuildContext context,
  }) {
    context.pushNamed(AppRoute.leads.name, extra: event);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );

    return eventsState.when(
      data: (List<Event> events) {
        final filteredEvents = events.where((e) => e.saved).toList();

        return EventsGrid(
          onTap: (event) => _navigateToLeadsPage(
            event: event,
            context: context,
          ),
          events: filteredEvents,
          placeholder: const YourEventsPlaceholder(),
          scrollController: scrollController,
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: CenteredProgressIndicator(),
      ),
      error: (error, __) {
        return SliverToBoxAdapter(
          child: Center(
            child: Text("❌ -> Failed to fetch Events. Error: $error"),
          ),
        );
      },
    );
  }
}
