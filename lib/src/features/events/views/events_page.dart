import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/events_controller.dart';
import '../data/providers.dart';
import '../widgets/events_page_background.dart';
import '../widgets/events_page_sliver_title.dart';
import '../widgets/events_sliver_grid_title.dart';
import '../widgets/coming_events_grid.dart';
import '../widgets/your_events_grid.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          EventsPageBackground(),
          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 20.0),
            child: EventsPageContentScrollView(),
          ),
        ],
      ),
    );
  }
}

class EventsPageContentScrollView extends ConsumerStatefulWidget {
  const EventsPageContentScrollView({super.key});

  @override
  ConsumerState createState() => _EventsPageContentScrollViewState();
}

class _EventsPageContentScrollViewState
    extends ConsumerState<EventsPageContentScrollView> {
  @override
  void initState() {
    super.initState();
    fetchEventsFromJson().then((events) {
      ref.read(eventsControllerProvider.notifier).processEvents(events);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: EventsPageSliverTitle(),
        ),
        SliverToBoxAdapter(
          child: EventsSliverGridTitle(title: "Your Events"),
        ),
        YourEventsGrid(),
        SliverToBoxAdapter(
          child: EventsSliverGridTitle(title: "Coming Events"),
        ),
        ComingEventsGrid(),
      ],
    );
  }
}
