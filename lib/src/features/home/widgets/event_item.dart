import 'package:flutter/material.dart';

import 'event_card.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    this.onTap,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: EventCard(
            imageAsset: imageAsset,
          ),
        ),
        const SizedBox(height: 5.0),
        // TODO: Design -> maxLines?
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
