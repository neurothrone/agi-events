import 'package:flutter/material.dart';

class EventsSliverGrid extends StatelessWidget {
  const EventsSliverGrid({
    Key? key,
    required this.eventIds,
    required this.builder,
  }) : super(key: key);

  final List<String> eventIds;
  final Widget Function(BuildContext context, int index) builder;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: eventIds.length,
          builder,
        ),
      ),
    );
  }
}
