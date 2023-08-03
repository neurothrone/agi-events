import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.0,
            MediaQuery.orientationOf(context) == Orientation.portrait
                ? 0.20
                : 0.39,
            1.0
          ],
          colors: [
            Colors.blue.shade900,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
    );
  }
}
