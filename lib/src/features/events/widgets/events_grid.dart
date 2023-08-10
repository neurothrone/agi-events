import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/event.dart';
import '../../../core/widgets/centered_progress_indicator.dart';
import '../data/events_controller.dart';
import 'event_grid_tile.dart';
import 'events_sliver_grid.dart';

class EventsGrid extends ConsumerStatefulWidget {
  const EventsGrid({
    required this.filter,
    required this.placeholder,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final bool Function(Event) filter;
  final Widget placeholder;
  final void Function(Event, BuildContext, WidgetRef) onTap;

  @override
  ConsumerState createState() => _EventsGridState();
}

class _EventsGridState extends ConsumerState<EventsGrid>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );

    return eventsState.when(
      data: (List<Event> events) {
        List<Event> filteredEvents = events.where(widget.filter).toList();

        if (filteredEvents.isEmpty) {
          return SliverToBoxAdapter(
            child: widget.placeholder,
          );
        }

        // Start the animation here if it hasn't started yet
        if (!_animationController.isAnimating &&
            !_animationController.isCompleted) {
          _animationController.forward();
        }

        return EventsSliverGrid(
          eventsLength: filteredEvents.length,
          builder: (context, index) {
            final event = filteredEvents[index];

            return AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, _) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: EventGridTile(
                    onTap: () => widget.onTap(event, context, ref),
                    event: event,
                  ),
                );
              },
            );
          },
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
