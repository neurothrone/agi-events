import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeadsCsvExportButton extends StatelessWidget {
  const LeadsCsvExportButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.share : Icons.share,
      ),
    );
  }
}
