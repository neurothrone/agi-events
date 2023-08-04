import 'package:flutter/material.dart';

class EventsPageHeader extends StatelessWidget {
  const EventsPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        right: 20.0,
        bottom: 5.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const EventsPageTitleText(),
          const SizedBox(height: 40.0),
          const EventsPageSubtitleText(),
        ]),
      ),
    );
  }
}

class EventsPageTitleText extends StatelessWidget {
  const EventsPageTitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome to\nAGI Events",
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class EventsPageSubtitleText extends StatelessWidget {
  const EventsPageSubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Coming Events",
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
