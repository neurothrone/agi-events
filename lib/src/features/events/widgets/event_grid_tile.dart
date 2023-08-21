import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/models.dart';

class EventGridTile extends StatelessWidget {
  const EventGridTile({
    super.key,
    this.onTap,
    required this.event,
  });

  final VoidCallback? onTap;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Material(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              color: AppConstants.primaryBlueDarker,
              elevation: AppDimensions.elevation,
              shadowColor: AppConstants.primaryBlueDarker,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.s8),
                  child: Hero(
                    tag: "event-${event.eventId}",
                    child: SvgPicture.asset(
                      AssetsConstants.imagePath(event.image),
                      semanticsLabel: "Event logo",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.s8,
              left: AppSizes.s8,
              right: AppSizes.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  event.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
