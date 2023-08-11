import 'package:flutter/material.dart';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/event.dart';
import '../../../core/widgets/centered_progress_indicator.dart';
import '../data/events_controller.dart';
import 'event_grid_tile.dart';

class EventsGrid extends ConsumerWidget {
  const EventsGrid({
    Key? key,
    required this.onTap,
    required this.filter,
    required this.placeholder,
    required this.scrollController,
  }) : super(key: key);

  final void Function(Event, BuildContext, WidgetRef) onTap;
  final bool Function(Event) filter;
  final Widget placeholder;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );

    return eventsState.when(
      data: (List<Event> events) {
        List<Event> filteredEvents = events.where(filter).toList();

        if (filteredEvents.isEmpty) {
          return SliverToBoxAdapter(
            child: placeholder,
          );
        }

        final Orientation orientation = MediaQuery.orientationOf(context);

        return LiveSliverGrid.options(
          controller: scrollController,
          options: const LiveOptions(
            showItemInterval: Duration(milliseconds: 250),
            showItemDuration: Duration(milliseconds: 250),
            visibleFraction: 0.025,
            reAnimateOnVisibility: false,
          ),
          itemBuilder: (
            BuildContext context,
            int index,
            Animation<double> animation,
          ) {
            final event = filteredEvents[index];

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(animation),
                child: EventGridTile(
                  onTap: () => onTap(event, context, ref),
                  event: event,
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: orientation == Orientation.portrait ? 0.65 : 0.7,
          ),
          itemCount: filteredEvents.length,
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

int determineCrossAxisCount(double width) {
  if (width < 400) {
    return 2;
  } else if (width < 600) {
    return 3;
  } else if (width < 900) {
    return 4;
  } else {
    return 5;
  }
}
