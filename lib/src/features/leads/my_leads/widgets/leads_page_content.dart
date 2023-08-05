import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/models/models.dart';
import '../../add_lead/data/leads_controller.dart';
import '../../add_lead/views/add_lead_sheet.dart';
import 'lead_row.dart';
import 'text_row_button.dart';

class LeadsPageContent extends ConsumerWidget {
  const LeadsPageContent({
    super.key,
    required this.eventId,
    required this.imageAsset,
  });

  final String eventId;
  final String imageAsset;

  void _showAddLeadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.9,
          child: AddLeadSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Lead>> leadsState = ref.watch(
      leadsControllerProvider(eventId),
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
                    child: SvgPicture.asset(imageAsset),
                  ),
                  const SizedBox(height: 20.0),
                  TextRowButton(
                    text: "Your leads",
                    onTap: () => _showAddLeadSheet(context),
                  ),
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

class EmptyLeadsPlaceholder extends StatelessWidget {
  const EmptyLeadsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20.0),
        Text(
          "You have no leads yet",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
