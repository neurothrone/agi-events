import 'package:flutter/material.dart';

class EventsSliverGrid extends StatelessWidget {
  const EventsSliverGrid({
    Key? key,
    required this.eventsLength,
    required this.builder,
  }) : super(key: key);

  final int eventsLength;
  final Widget Function(BuildContext context, int index) builder;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.orientationOf(context) == Orientation.portrait ? 2 : 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.65,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: eventsLength,
        builder,
      ),
    );
  }
}
