import 'package:flutter/material.dart';

import 'home_background.dart';
import 'home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          HomeBackground(),
          HomeContent(),
        ],
      ),
    );
  }
}
