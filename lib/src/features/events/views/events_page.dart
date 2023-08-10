import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/event.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../leads/my_leads/views/leads_page.dart';
import '../../leads/qr_scan/data/qr_scan_controller.dart';
import '../data/events_controller.dart';
import '../data/providers.dart';
import '../widgets/event_grid_tile.dart';
import '../widgets/events_page_background.dart';
import '../widgets/events_page_sliver_title.dart';
import '../widgets/events_sliver_grid.dart';
import '../widgets/events_sliver_grid_title.dart';
import '../widgets/your_events_placeholder.dart';

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

class EventsPageContent extends ConsumerStatefulWidget {
  const EventsPageContent({super.key});

  @override
  ConsumerState createState() => _EventsPageContentState();
}

class _EventsPageContentState extends ConsumerState<EventsPageContent>
    with TickerProviderStateMixin {
  late Future<List<Event>> _eventsFuture;

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

    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _eventsFuture = fetchEventsFromJson().then((List<Event> events) {
      // When the future completes, call processEvents
      ref.read(eventsControllerProvider.notifier).processEvents(events);

      _animationController.forward();

      return events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: child,
                );
              },
              child: const EventsPageContentGrids(),
            );
          }
        } else {
          // While the future is still running
          return const CenteredProgressIndicator();
        }
      },
    );
  }
}

class EventsPageContentGrids extends ConsumerWidget {
  const EventsPageContentGrids({super.key});

  Future<void> _openQrScanner({
    required Event event,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    await ref.read(qrScanControllerProvider).showQrScanner(
          scanType: ScanType.exhibitor,
          context: context,
          onQrCodeScanned: (String qrCode) async {
            await ref
                .read(eventsControllerProvider.notifier)
                .addEventByExhibitorId(
                    exhibitorId: qrCode,
                    event: event,
                    onError: (String message) {
                      showSnackbar(
                        message: message,
                        context: context,
                      );
                    });
          },
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
        slivers.add(
          const EventsSliverGridTitle(title: "Your Events"),
        );
        if (yourEvents.isNotEmpty) {
          slivers.addAll([
            EventsSliverGrid(
              eventsLength: yourEvents.length,
              builder: (context, index) {
                final event = yourEvents[index];

                return EventGridTile(
                  onTap: () => Navigator.push(
                    context,
                    LeadsPage.route(event: event),
                  ),
                  event: event,
                );
              },
            ),
          ]);
        } else {
          slivers.add(
            const YourEventsPlaceholder(),
          );
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
                  onTap: () => _openQrScanner(
                    event: event,
                    context: context,
                    ref: ref,
                  ),
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
      loading: () => const CenteredProgressIndicator(),
      error: (error, __) {
        return Center(
          child: Text("❌ -> Failed to fetch Events. Error: $error"),
        );
      },
    );
  }
}
