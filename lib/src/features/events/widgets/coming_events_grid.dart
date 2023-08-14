import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/enums/enums.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/centered_progress_indicator.dart';
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
        // Cache `now`
        final now = DateTime.now();

        return EventsGrid(
          onTap: (event, context, ref) {
            _openQrScanner(
              event: event,
              context: context,
              ref: ref,
            );
          },
          filter: (event) => !event.saved && event.endDate.isNotAfter(now),
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
