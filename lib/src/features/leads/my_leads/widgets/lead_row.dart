import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../../../routing/routing.dart';
import 'lead_text_icon_row.dart';

class LeadRow extends StatelessWidget {
  const LeadRow({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.pushNamed(
            AppRoute.leadDetail.name,
            extra: lead,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.s10),
                    LeadTextIconRow(
                      text: lead.fullName,
                      icon: Icons.person_rounded,
                      textColor: Colors.white,
                      fontSize: 18.0,
                    ),
                    const SizedBox(height: AppSizes.s4),
                    LeadTextIconRow(
                      text: lead.company,
                      icon: Icons.business_rounded,
                      textColor: Colors.white70,
                      fontSize: 17.0,
                    ),
                    const SizedBox(height: AppSizes.s4),
                    LeadTextIconRow(
                      text: lead.scannedAt.formatted,
                      icon: Icons.access_time_rounded,
                      textColor: Colors.white54,
                      fontSize: 16.0,
                    ),
                    const SizedBox(height: AppSizes.s10),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.s20),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
