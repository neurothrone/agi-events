import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/assets_constants.dart';
import '../../leads/my_leads/data/events_controller.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String>> eventsState = ref.watch(
      eventsControllerProvider,
    );
    return eventsState.when(
      data: (List<String> eventsIds) {
        List<Widget> slivers = [
          const EventsPageSliverTitle(),
        ];

        if (eventsIds.isNotEmpty) {
          slivers.addAll([
            const EventsSliverGridTitle(title: "Your Events"),
            EventsSliverGrid(
              eventIds: eventsIds,
              builder: (context, index) => EventGridTile(
                onTap: () {
                  debugPrint("ℹ️ -> Event item tapped");
                },
                imageAsset: AssetsConstants.signPrintScandinaviaLogo,
                title: "Title",
                subtitle: "Subtitle",
              ),
            ),
          ]);
        }

        if (eventsIds.isNotEmpty) {
          slivers.addAll([
            const EventsSliverGridTitle(title: "Coming Events"),
            EventsSliverGrid(
              eventIds: eventsIds,
              builder: (context, index) => EventGridTile(
                onTap: () {
                  debugPrint("ℹ️ -> Event item tapped");
                },
                imageAsset: AssetsConstants.signPrintScandinaviaLogo,
                title: "Title",
                subtitle: "Subtitle",
              ),
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
