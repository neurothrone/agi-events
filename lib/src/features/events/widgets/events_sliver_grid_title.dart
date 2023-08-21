import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class EventsSliverGridTitle extends StatelessWidget {
  const EventsSliverGridTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
