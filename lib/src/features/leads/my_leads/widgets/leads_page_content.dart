import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import 'leads_list.dart';
import 'leads_page_overview.dart';

class LeadsPageContentScrollView extends StatelessWidget {
  const LeadsPageContentScrollView({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LeadsPageOverview(event: event),
          ),
          LeadsList(event: event),
        ],
      ),
    );
  }
}
