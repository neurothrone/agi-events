import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class LeadTextIconRow extends StatelessWidget {
  const LeadTextIconRow({
    super.key,
    required this.text,
    required this.icon,
    this.textColor = Colors.white,
    this.fontSize = 18.0,
  });

  final String text;
  final IconData icon;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: AppSizes.s20),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
