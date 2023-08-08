import 'package:flutter/material.dart';

class AddLeadTitleText extends StatelessWidget {
  const AddLeadTitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "New lead",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
