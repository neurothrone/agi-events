import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class LeadDetailTextIconRow extends StatelessWidget {
  const LeadDetailTextIconRow({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: AppSizes.s20),
        const SizedBox(width: AppSizes.s8),
        Text(text),
      ],
    );
  }
}
