import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../lead_detail/views/lead_detail_page.dart';

class LeadRow extends StatelessWidget {
  const LeadRow({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeadDetailPage(
                  lead: lead,
                ),
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.fullName,
                        style: const TextStyle(fontSize: 17.0),
                      ),
                      Text(
                        lead.company,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    lead.scannedAt.formatted,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
