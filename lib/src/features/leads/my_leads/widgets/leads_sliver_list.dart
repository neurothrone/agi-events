import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import 'lead_row.dart';

class LeadsSliverList extends StatelessWidget {
  const LeadsSliverList({
    super.key,
    required this.leads,
  });

  final List<Lead> leads;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => LeadRow(lead: leads[index]),
        childCount: leads.length,
      ),
    );
  }
}
