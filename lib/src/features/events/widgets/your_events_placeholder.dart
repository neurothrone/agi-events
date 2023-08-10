import 'package:flutter/material.dart';

class YourEventsPlaceholder extends StatelessWidget {
  const YourEventsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "You do not have events yet. Tap on "
                  "an Event in the ",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            TextSpan(
              text: "Coming Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: " section and Scan the QR code of "
                  "your exhibitor badge.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
