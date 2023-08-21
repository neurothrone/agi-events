import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import 'leads_list.dart';
import 'leads_page_header.dart';

class LeadsPageContentScrollView extends StatelessWidget {
  const LeadsPageContentScrollView({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: AppSizes.s20),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: LeadsPageHeader(event: event),
          ),
          LeadsList(event: event),
        ],
      ),
    );
  }
}
