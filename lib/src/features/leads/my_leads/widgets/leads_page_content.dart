import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/models.dart';
import '../../add_lead/data/leads_controller.dart';
import 'empty_leads_placeholder.dart';
import 'lead_row.dart';
import 'add_lead_text_row_button.dart';

class LeadsPageContent extends ConsumerWidget {
  const LeadsPageContent({
    super.key,
    required this.eventId,
    required this.imageAsset,
  });

  final String eventId;
  final String imageAsset;

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
                      imageAsset,
                      // TODO: temporary until SVG:s fixed
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const AddLeadTextRowButton(),
                  const Divider(color: Colors.white12),
                  if (leads.isEmpty) const EmptyLeadsPlaceholder(),
                ],
              ),
            ),
            if (leads.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      LeadRow(lead: leads[index]),
                  childCount: leads.length,
                ),
              ),
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
  }
}
