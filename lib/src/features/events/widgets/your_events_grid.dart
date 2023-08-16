import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/widgets/centered_progress_indicator.dart';
import '../data/events_controller.dart';
import 'your_events_placeholder.dart';
import 'events_grid.dart';

class YourEventsGrid extends ConsumerWidget {
  const YourEventsGrid({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );

    return eventsState.when(
      data: (List<Event> events) {
        return EventsGrid(
          onTap: (event, context, _) {
            context.pushNamed(AppRoute.leads.name, extra: event);
          },
          filter: (event) => event.saved,
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
