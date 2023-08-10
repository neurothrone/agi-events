import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../data/leads_controller.dart';
import 'empty_leads_placeholder.dart';
import 'leads_sliver_list.dart';

class LeadsList extends ConsumerStatefulWidget {
  const LeadsList({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  ConsumerState createState() => _LeadsListState();
}

class _LeadsListState extends ConsumerState<LeadsList> {
  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    ref
        .read(leadsControllerProvider.notifier)
        .fetchLeadsByEventId(widget.event.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Lead>> leadsState = ref.watch(
      leadsControllerProvider,
    );

    return leadsState.when(
      data: (List<Lead> leads) {
        if (leads.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyLeadsPlaceholder(),
          );
        }

        return LeadsSliverList(leads: leads);
      },
      loading: () => const CenteredProgressIndicator(),
      error: (error, __) {
        return Center(
          child: Text("❌ -> Error fetching leads. Error: $error"),
        );
      },
    );
  }
}
