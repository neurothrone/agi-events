import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TextIconRow extends StatelessWidget {
  const TextIconRow({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: AppSizes.s16),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
