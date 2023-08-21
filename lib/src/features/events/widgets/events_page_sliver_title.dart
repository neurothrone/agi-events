import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class EventsPageSliverTitle extends StatelessWidget {
  const EventsPageSliverTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSizes.s20, bottom: AppSizes.s40),
      child: Text(
        "Welcome to\n${AppConstants.appTitle}",
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
