import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_constants.dart';

class EventGridTile extends StatelessWidget {
  const EventGridTile({
    super.key,
    this.onTap,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback? onTap;
  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: AppConstants.primaryBlueLighter,
              elevation: 3.0,
              shadowColor: AppConstants.primaryBlueLighter,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    imageAsset,
                    semanticsLabel: "Event logo",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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
