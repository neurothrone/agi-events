import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
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
              const SizedBox(height: AppSizes.s10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.fullName,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: AppSizes.s2),
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
              const SizedBox(height: AppSizes.s10),
            ],
          ),
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
