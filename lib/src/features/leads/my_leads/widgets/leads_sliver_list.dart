import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
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
        childCount: leads.length,
        (BuildContext context, int index) => TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(
            milliseconds: AppConstants.animationDuration,
          ),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: LeadRow(lead: leads[index]),
            );
          },
        ),
      ),
    );
  }
}
