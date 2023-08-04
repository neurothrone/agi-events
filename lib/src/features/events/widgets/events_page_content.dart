import 'package:flutter/material.dart';

import 'coming_events_grid.dart';
import 'events_page_header.dart';

class EventsPageContent extends StatelessWidget {
  const EventsPageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: CustomScrollView(
        slivers: [
          EventsPageHeader(),
          ComingEventsGrid(),
        ],
      ),
    );
  }
}
