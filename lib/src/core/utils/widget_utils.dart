import 'package:flutter/material.dart';

import '../constants/constants.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppConstants.primaryBlueLighter,
    elevation: AppDimensions.elevation,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return child;
    },
  );
}
