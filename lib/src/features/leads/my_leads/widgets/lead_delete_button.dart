import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

class LeadDeleteButton extends StatelessWidget {
  const LeadDeleteButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: "Delete Lead",
      height: 50.0,
      icon: Platform.isIOS ? CupertinoIcons.trash : Icons.delete,
      backgroundColor: AppConstants.destructive,
    );
  }
}
