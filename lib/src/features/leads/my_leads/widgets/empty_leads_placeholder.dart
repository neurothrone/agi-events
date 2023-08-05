import 'package:flutter/material.dart';

class EmptyLeadsPlaceholder extends StatelessWidget {
  const EmptyLeadsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20.0),
        Text(
          "You have no leads yet",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
