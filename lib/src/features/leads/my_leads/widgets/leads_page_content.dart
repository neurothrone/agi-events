import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../data/leads_controller.dart';
import 'empty_leads_placeholder.dart';
import 'event_leads_overview.dart';
import 'leads_sliver_list.dart';

class LeadsPageContent extends ConsumerWidget {
  const LeadsPageContent({
    super.key,
    this.onAddPressed,
    required this.event,
  });

  final VoidCallback? onAddPressed;
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Lead>> leadsState = ref.watch(
      leadsControllerProvider,
    );

    return leadsState.when(
      data: (List<Lead> leads) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                    child: SvgPicture.asset(
                      AssetsConstants.imagePath(event.image),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  EventLeadsOverview(
                    text: "Your leads",
                    onTap: onAddPressed,
                  ),
                  const Divider(color: Colors.white12),
                  if (leads.isEmpty) const EmptyLeadsPlaceholder(),
                ],
              ),
            ),
            if (leads.isNotEmpty) LeadsSliverList(leads: leads),
          ],
        );
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
