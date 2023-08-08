import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomCupertinoAppBar extends StatelessWidget {
  const CustomCupertinoAppBar({
    super.key,
    this.onBackButtonPressed,
    this.title,
    this.trailing,
  });

  final VoidCallback? onBackButtonPressed;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: Colors.black,
      padding: EdgeInsetsDirectional.zero,
      leading: Navigator.canPop(context)
          ? CupertinoNavigationBarBackButton(
              onPressed: onBackButtonPressed ??
                  () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
              color: AppConstants.primaryBlueLightest,
              previousPageTitle: "Back",
            )
          : null,
      middle: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}
