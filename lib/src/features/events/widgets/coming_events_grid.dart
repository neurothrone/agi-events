import 'package:flutter/material.dart';

import '../../../core/constants/assets_constants.dart';
import '../../leads/my_leads/views/leads_page.dart';
import 'event_item.dart';

class ComingEventsGrid extends StatelessWidget {
  const ComingEventsGrid({super.key});

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
        // TODO: Replace Grid items with real data
        children: List.generate(4, (index) {
          return EventItem(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeadsPage(
                    imageAsset: AssetsConstants.signPrintScandinaviaLogo,
                  ),
                ),
              );
              debugPrint("ℹ️ -> EventItem tapped.");
            },
            title: "Sign & Print Scandinavia 2023",
            subtitle: "19-21 Sep",
            imageAsset: AssetsConstants.signPrintScandinaviaLogo,
          );
        }),
      ),
    );
  }
}
