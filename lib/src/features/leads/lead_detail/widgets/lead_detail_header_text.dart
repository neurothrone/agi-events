import 'package:flutter/material.dart';

class LeadDetailHeaderText extends StatelessWidget {
  const LeadDetailHeaderText({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
