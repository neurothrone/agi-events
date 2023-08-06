import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/event.dart';
import '../../leads/my_leads/data/events_controller.dart';
import '../../leads/my_leads/views/leads_page.dart';
import '../widgets/event_grid_tile.dart';
import '../widgets/events_page_background.dart';
import '../widgets/events_page_sliver_title.dart';
import '../widgets/events_sliver_grid.dart';
import '../widgets/events_sliver_grid_title.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          EventsPageBackground(),
          EventsPageContent(),
        ],
      ),
    );
  }
}

class EventsPageContent extends ConsumerWidget {
  const EventsPageContent({
    super.key,
  });

  void _openQrScanner(
    String eventId,
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.read(eventsControllerProvider.notifier).openQrScanner(
          eventId: eventId,
          context: context,
        );
  }

  void _navigateToLeadsForEvent(
    Event event,
    BuildContext context,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeadsPage(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );
    return eventsState.when(
      data: (List<Event> events) {
        List<Widget> slivers = [
          const EventsPageSliverTitle(),
        ];

        List<Event> yourEvents = [];
        List<Event> comingEvents = [];

        for (final event in events) {
          if (event.saved) {
            yourEvents.add(event);
          } else {
            comingEvents.add(event);
          }
        }

        // !: Your Events
        if (yourEvents.isNotEmpty) {
          slivers.addAll([
            const EventsSliverGridTitle(title: "Your Events"),
            EventsSliverGrid(
              eventsLength: yourEvents.length,
              builder: (context, index) {
                final event = yourEvents[index];

                return EventGridTile(
                  onTap: () => _navigateToLeadsForEvent(event, context),
                  event: event,
                );
              },
            ),
          ]);
        }

        // !: Coming Events
        if (comingEvents.isNotEmpty) {
          slivers.addAll([
            const EventsSliverGridTitle(title: "Coming Events"),
            EventsSliverGrid(
              eventsLength: comingEvents.length,
              builder: (context, index) {
                final Event event = comingEvents[index];

                return EventGridTile(
                  onTap: () => _openQrScanner(event.eventId, context, ref),
                  event: event,
                );
              },
            )
          ]);
        }

        return SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomScrollView(slivers: slivers),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, __) {
        return Center(
          child: Text("❌ -> Failed to fetch Events. Error: $error"),
        );
      },
    );
  }
}
