import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
