import 'package:flutter/material.dart';

import 'package:auto_animated/auto_animated.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/models/models.dart';
import 'event_grid_tile.dart';

class EventsGrid extends StatelessWidget {
  const EventsGrid({
    Key? key,
    required this.onTap,
    required this.events,
    required this.placeholder,
    required this.scrollController,
  }) : super(key: key);

  final void Function(Event) onTap;
  final List<Event> events;
  final Widget placeholder;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return SliverToBoxAdapter(
        child: placeholder,
      );
    }

    return LiveSliverGrid.options(
      controller: scrollController,
      options: const LiveOptions(
        showItemInterval: Duration(milliseconds: 250),
        showItemDuration: Duration(milliseconds: 250),
        visibleFraction: 0.025,
        reAnimateOnVisibility: false,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: AppSizes.s20,
        childAspectRatio: 0.65,
      ),
      itemCount: events.length,
      itemBuilder: (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) {
        final event = events[index];

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
              onTap: () => onTap(event),
              event: event,
            ),
          ),
        );
      },
    );
  }
}
