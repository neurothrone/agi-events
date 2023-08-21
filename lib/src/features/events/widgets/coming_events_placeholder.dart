import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class ComingEventsPlaceholder extends StatelessWidget {
  const ComingEventsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSizes.s20),
      child: Text(
        "There are no events yet, stay tuned!",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
