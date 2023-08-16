import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/models/models.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/utils.dart';

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
          onTap: () => context.pushNamed(AppRoute.leadDetail.name, extra: lead),
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
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        lead.company,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    lead.scannedAt.formatted,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
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
