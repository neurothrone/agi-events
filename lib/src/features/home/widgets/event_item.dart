import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

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

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.imageAsset,
    this.height = 150.0,
    this.padding = 10.0,
    this.borderRadius = 10.0,
  });

  final String imageAsset;
  final double height;
  final double padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey.shade800,
      ),
      child: SvgPicture.asset(
        imageAsset,
        semanticsLabel: "Event logo",
      ),
    );
  }
}
