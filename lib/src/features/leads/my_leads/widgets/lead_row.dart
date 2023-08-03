import 'package:flutter/material.dart';

class LeadRow extends StatelessWidget {
  const LeadRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
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
        Divider(color: Colors.white12),
      ],
    );
  }
}
