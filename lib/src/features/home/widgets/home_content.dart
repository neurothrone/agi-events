import 'package:flutter/material.dart';

import 'coming_events_grid.dart';
import 'home_header.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: CustomScrollView(
        slivers: [
          HomeHeader(),
          ComingEventsGrid(),
        ],
      ),
    );
  }
}
