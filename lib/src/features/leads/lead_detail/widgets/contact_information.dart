import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/models.dart';
import 'lead_detail_text_icon_row.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeadDetailTextIconRow(
            text: lead.fullName,
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 10.0),
          LeadDetailTextIconRow(
            text: lead.company,
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: 10.0),
          LeadDetailTextIconRow(
            text: lead.email,
            icon: Icons.email_rounded,
          ),
          if (lead.phone != null) ...[
            const SizedBox(height: 10.0),
            LeadDetailTextIconRow(
              text: lead.phone!,
              icon: Icons.phone_rounded,
            ),
          ],
        ],
      ),
    );
  }
}
