import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share_rounded,
        color: AppConstants.primaryBlueLightest,
        semanticLabel: "Share CSV",
      ),
    );
  }
}
