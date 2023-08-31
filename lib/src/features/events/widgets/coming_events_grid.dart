import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../routing/routing.dart';
import '../../qr_scan/data/qr_scan_controller.dart';
import '../data/events_controller.dart';
import 'coming_events_placeholder.dart';
import 'events_grid.dart';

class ComingEventsGrid extends ConsumerWidget {
  const ComingEventsGrid({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  Future<void> _openQrScanner({
    required Event event,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    await ref.read(qrScanControllerProvider).showQrScanner(
          scanType: ScanType.exhibitor,
          showAppBar: true,
          showPlaceholder: true,
          context: context,
          onQrCodeScanned: (String qrCode) async {
            await _addEventByExhibitorId(
              exhibitorId: qrCode,
              event: event,
              context: context,
              ref: ref,
            );
          },
        );
  }

  Future<void> _addEventByExhibitorId({
    required String exhibitorId,
    required Event event,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final Event? newEvent =
        await ref.read(eventsControllerProvider.notifier).addEventByExhibitorId(
            exhibitorId: exhibitorId,
            event: event,
            onError: (String message) {
              showSnackbar(
                message: message,
                context: context,
              );
            });

    if (newEvent != null && context.mounted) {
      context.pushNamed(AppRoute.leads.name, extra: newEvent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Event>> eventsState = ref.watch(
      eventsControllerProvider,
    );

    return eventsState.when(
      data: (List<Event> events) {
        // Cache `now`
        final now = DateTime.now();
        final filteredEvents =
            events.where((e) => !e.saved && e.endDate.isNotAfter(now)).toList();

        return EventsGrid(
          onTap: (event) => _openQrScanner(
            event: event,
            context: context,
            ref: ref,
          ),
          events: filteredEvents,
          placeholder: const ComingEventsPlaceholder(),
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
