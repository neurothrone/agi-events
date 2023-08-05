import 'package:flutter/material.dart';

import '../constants/constants.dart';

Future<T?> showCustomBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return await showModalBottomSheet(
    context: context,
    backgroundColor: AppConstants.primaryBlueLighter,
    elevation: 2.0,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return child;
    },
  );
}
