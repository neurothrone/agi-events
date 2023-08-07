import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../add_lead/data/leads_controller.dart';
import 'empty_leads_placeholder.dart';
import 'add_lead_text_row_button.dart';
import 'leads_sliver_list.dart';

class LeadsPageContent extends ConsumerWidget {
  const LeadsPageContent({
    super.key,
    required this.event,
  });

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
                    child: SvgPicture.asset("assets/images/${event.image}.svg"),
                  ),
                  const SizedBox(height: 20.0),
                  const AddLeadTextRowButton(),
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
