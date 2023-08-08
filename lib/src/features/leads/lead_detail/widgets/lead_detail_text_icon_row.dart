import 'package:flutter/material.dart';

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
        Icon(icon, color: Colors.grey, size: 20.0),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }
}
