import 'package:flutter/material.dart';

import '../../../core/constants/assets_constants.dart';
import '../../leads/my_leads/views/leads_page.dart';
import 'event_item.dart';

class EventsGrid extends StatelessWidget {
  const EventsGrid({
    super.key,
    required this.eventIds,
  });

  final List<String> eventIds;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      sliver: SliverGrid.count(
        // TODO: If device width is too small change crossAxisCount to 1
        crossAxisCount: 2,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio:
            MediaQuery.orientationOf(context) == Orientation.portrait
                ? 0.75
                : 1.8,
        children: eventIds.map((eventId) {
          return EventItem(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeadsPage(
                    eventId: eventId,
                    imageAsset: AssetsConstants.signPrintScandinaviaLogo,
                  ),
                ),
              );
              debugPrint("ℹ️ -> Event [$eventId] tapped.");
            },
            title: "Sign & Print Scandinavia 2023",
            subtitle: "19-21 Sep",
            imageAsset: AssetsConstants.signPrintScandinaviaLogo,
          );
        }).toList(),
      ),
    );
  }
}
