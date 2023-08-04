import 'package:flutter/material.dart';

import '../views/lead_detail_page.dart';

class LeadRow extends StatelessWidget {
  const LeadRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LeadDetailPage(),
              ),
            );
          },
          child: const Column(
            children: [
              SizedBox(height: 10.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("John Doe"),
                      Text("AGI Events"),
                    ],
                  ),
                  Spacer(),
                  Text(
                    "10:18, 18 Aug",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
