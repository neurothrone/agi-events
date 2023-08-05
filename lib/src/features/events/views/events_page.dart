import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../leads/my_leads/data/events_controller.dart';
import '../widgets/events_grid.dart';
import '../widgets/events_page_background.dart';
import '../widgets/events_page_header.dart';

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

class EventsPageContent extends StatelessWidget {
  const EventsPageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, WidgetRef ref, child) {
          final AsyncValue<List<String>> eventsState = ref.watch(
            eventsControllerProvider,
          );

          return eventsState.when(
            data: (List<String> eventsIds) {
              return CustomScrollView(
                slivers: [
                  const EventsPageHeader(),
                  EventsGrid(eventIds: eventsIds),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, __) {
              return Center(
                child: Text("❌ -> Error fetching leads. Error: $error"),
              );
            },
          );
        },
      ),
    );
  }
}
