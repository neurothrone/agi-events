import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../add_lead/views/add_lead_sheet.dart';
import 'add_lead_icon_button.dart';

class LeadsPageHeader extends SliverPersistentHeaderDelegate {
  const LeadsPageHeader({
    required this.event,
    this.imageHeight = 100.0,
  });

  final Event event;
  final double imageHeight;

  // Height of the Widget after collapsing
  @override
  double get minExtent => 70.0;

  // Height of the Widget before collapsing
  @override
  double get maxExtent => imageHeight + minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  void _showAddLeadSheet(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      child: AddLeadSheet(event: event),
    );
  }

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    // Calculate the opacity of the image as we scroll
    final double opacity = (1 - shrinkOffset / maxExtent).clamp(0, 1);

    // Calculate remaining space for the image after shrinking
    final double imageHeight = (this.imageHeight - shrinkOffset).clamp(0, 100);

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: imageHeight,
            child: Opacity(
              opacity: opacity,
              child: Hero(
                tag: "event-${event.eventId}",
                child: SvgPicture.asset(
                  AssetsConstants.imagePath(event.image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Your leads",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              AddLeadIconButton(
                onTap: () => _showAddLeadSheet(context),
              ),
            ],
          ),
          const Divider(
            color: AppConstants.primaryBlue,
            height: 20.0,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
