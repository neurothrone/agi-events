import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CenteredProgressIndicator extends StatelessWidget {
  const CenteredProgressIndicator({
    super.key,
    this.color = AppConstants.primaryBlue,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
