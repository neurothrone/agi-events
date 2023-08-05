import 'package:flutter/material.dart';

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
        const SizedBox(width: 15.0),
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
